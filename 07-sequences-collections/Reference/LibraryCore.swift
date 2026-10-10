struct Video: Identifiable, Equatable {
    let id: Int
    let title: String
    var isDownloaded: Bool
    let bytes: Int
}

let sampleVideos = [
    Video(id: 1, title: "Swift types", isDownloaded: true, bytes: 10),
    Video(id: 2, title: "Protocols", isDownloaded: false, bytes: 12),
    Video(id: 3, title: "Generics", isDownloaded: true, bytes: 8),
    Video(id: 4, title: "Numerics", isDownloaded: true, bytes: 14),
    Video(id: 5, title: "Collections", isDownloaded: false, bytes: 6)
]

struct ChunkRanges: Sequence {
    let total: Int
    let size: Int

    struct Iterator: IteratorProtocol {
        let total: Int
        let size: Int
        private var position = 0
        init(total: Int, size: Int) { self.total = total; self.size = size }
        mutating func next() -> Range<Int>? {
            guard total > 0, size > 0, position < total else { return nil }
            let length = Swift.min(size, total - position)
            let result = position..<(position + length)
            position = result.upperBound
            return result
        }
    }
    func makeIterator() -> Iterator { Iterator(total: total, size: size) }
}

enum LibraryError: Error { case invalidBatchSize }

func batches<C: Collection>(_ values: C, size: Int) throws -> [C.SubSequence] {
    guard size > 0 else { throw LibraryError.invalidBatchSize }
    var result: [C.SubSequence] = []
    var start = values.startIndex
    while start != values.endIndex {
        let end = values.index(start, offsetBy: size, limitedBy: values.endIndex) ?? values.endIndex
        result.append(values[start..<end])
        start = end
    }
    return result
}

func firstReadyTitles<S: Sequence>(_ videos: S, limit: Int) -> [String] where S.Element == Video {
    guard limit > 0 else { return [] }
    // The loop gives us explicit one-pass consumption and stopping behavior.
    var result: [String] = []
    for video in videos {
        if video.isDownloaded {
            result.append(video.title)
            if result.count == limit { break }
        }
    }
    return result
}
