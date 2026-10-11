import Foundation

// The API sends whole, nonnegative seconds as ASCII decimal text.
struct DurationSeconds: Codable, Equatable, Sendable {
    let value: Int
    init(_ value: Int) throws {
        guard value >= 0 else { throw LibraryFailure.invalidDuration }
        self.value = value
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        guard !raw.isEmpty, raw.utf8.allSatisfy({ (48...57).contains($0) }), let value = Int(raw) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected nonnegative whole seconds as ASCII decimal text")
        }
        self.value = value
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(value))
    }
}

enum Availability: Codable, Equatable, Sendable {
    case ready, processing, unknown(String)
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "ready": self = .ready
        case "processing": self = .processing
        case let raw: self = .unknown(raw)
        }
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    var rawValue: String {
        switch self { case .ready: "ready"; case .processing: "processing"; case .unknown(let raw): raw }
    }
}

struct VideoDTO: Decodable, Sendable {
    let id: String
    let title: String
    let summary: String?
    let duration: DurationSeconds
    let availability: Availability
    let tags: [String]
    enum CodingKeys: String, CodingKey {
        case id, title, summary, availability, tags
        case duration = "duration_seconds"
    }
    init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        summary = try c.decodeIfPresent(String.self, forKey: .summary)
        duration = try c.decode(DurationSeconds.self, forKey: .duration)
        availability = try c.decode(Availability.self, forKey: .availability)
        // Only absence means the older API had no tags. Explicit null is invalid.
        tags = c.contains(.tags) ? try c.decode([String].self, forKey: .tags) : []
    }
}

struct LibraryResponse: Decodable, Sendable {
    struct Metadata: Decodable, Sendable {
        let updatedAt: Date
        enum CodingKeys: String, CodingKey { case updatedAt = "updated_at" }
    }
    let metadata: Metadata
    let videos: [VideoDTO]
}

// Stable app model. API spelling and presentation state do not leak into it.
struct LibraryVideo: Codable, Equatable, Identifiable, Sendable {
    let id: String
    let title: String
    let summary: String?
    let duration: Int
    let availability: Availability
    let tags: [String]
}

enum LibraryFailure: Error, Equatable {
    case invalidDuration, invalidVideo, duplicateID, unsupportedVersion(Int), unfinished
}

func validateVideos(_ videos: [LibraryVideo]) throws -> [LibraryVideo] {
    var seen = Set<String>()
    for video in videos {
        guard !video.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !video.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              video.duration >= 0 else { throw LibraryFailure.invalidVideo }
        guard seen.insert(video.id).inserted else { throw LibraryFailure.duplicateID }
    }
    return videos
}

func decodeLibrary(_ data: Data) throws -> [LibraryVideo] {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let response = try decoder.decode(LibraryResponse.self, from: data)
    return try validateVideos(response.videos.map {
        LibraryVideo(id: $0.id, title: $0.title, summary: $0.summary, duration: $0.duration.value,
                     availability: $0.availability, tags: $0.tags)
    })
}

struct CacheEnvelope: Codable {
    let version: Int
    let videos: [LibraryVideo]
}
private struct CacheHeader: Decodable { let version: Int }
private struct LegacyCache: Decodable {
    struct Video: Decodable { let id: String; let title: String; let duration: Int }
    let videos: [Video]
}

func encodeCache(_ videos: [LibraryVideo]) throws -> Data {
    let checked = try validateVideos(videos)
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    return try encoder.encode(CacheEnvelope(version: 2, videos: checked))
}

func decodeCache(_ data: Data) throws -> [LibraryVideo] {
    let decoder = JSONDecoder()
    let header = try decoder.decode(CacheHeader.self, from: data)
    switch header.version {
    case 1:
        let old = try decoder.decode(LegacyCache.self, from: data)
        return try validateVideos(old.videos.map {
            LibraryVideo(id: $0.id, title: $0.title, summary: nil, duration: $0.duration,
                         availability: .ready, tags: [])
        })
    case 2:
        return try validateVideos(decoder.decode(CacheEnvelope.self, from: data).videos)
    default: throw LibraryFailure.unsupportedVersion(header.version)
    }
}

// Disk is injected so tests never touch the learner's actual cache.
struct LibraryCache {
    let url: URL
    func save(_ videos: [LibraryVideo]) throws {
        let data = try encodeCache(videos)
        try data.write(to: url, options: .atomic)
    }
    func load() throws -> [LibraryVideo] { try decodeCache(Data(contentsOf: url)) }
}

// Diagnostics intentionally omit payload values. Do not print production response bodies.
func decodingDiagnostic(_ error: any Error) -> String {
    func path(_ keys: [any CodingKey]) -> String {
        keys.reduce("$") { result, key in
            if let index = key.intValue { return result + "[\(index)]" }
            return result + "." + key.stringValue
        }
    }
    switch error {
    case DecodingError.keyNotFound(let key, let context): return "Missing key at " + path(context.codingPath + [key])
    case DecodingError.valueNotFound(_, let context): return "Unexpected null at " + path(context.codingPath)
    case DecodingError.typeMismatch(_, let context): return "Wrong type at " + path(context.codingPath)
    case DecodingError.dataCorrupted(let context): return "Invalid value at " + path(context.codingPath)
    case LibraryFailure.duplicateID: return "Duplicate video ID. Library unchanged."
    case LibraryFailure.unsupportedVersion(let version): return "Unsupported cache version \(version). Library unchanged."
    case LibraryFailure.unfinished: return "Complete the TODOs in LibraryCodec.swift."
    case is LibraryFailure: return "Invalid library data. Library unchanged."
    default: return "Could not read or write the local cache. Library unchanged."
    }
}
