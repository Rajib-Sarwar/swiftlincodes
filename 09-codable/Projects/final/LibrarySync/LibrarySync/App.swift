import SwiftUI

@main
struct LibrarySyncApp: App {
    var body: some Scene { WindowGroup { LibrarySyncView() } }
}
struct LibrarySyncView: View {
    @State private var fixture = Fixture.valid
    @State private var videos: [LibraryVideo] = []
    @State private var message = "Import a fixture to begin."
    @State private var json = ""
    private var cache: LibraryCache {
        LibraryCache(url: URL.documentsDirectory.appending(path: "swiftlin-library-v2.json"))
    }
    var body: some View {
        NavigationStack {
            List {
                Section("1 · Decode the API") {
                    Picker("Fixture", selection: $fixture) {
                        ForEach(Fixture.allCases) { Text($0.rawValue).tag($0) }
                    }
                    Button("Import selected fixture") {
                        do {
                            let replacement = try decodeLibrary(Data(fixture.json.utf8))
                            videos = replacement
                            message = "Imported \(videos.count) videos."
                        } catch { message = decodingDiagnostic(error) }
                    }
                    DisclosureGroup("Inspect fixture JSON") {
                        Text(fixture.json).font(.system(.caption, design: .monospaced)).textSelection(.enabled)
                    }
                }
                Section("Current library · \(videos.count)") {
                    if videos.isEmpty { Text("No imported videos yet.").foregroundStyle(.secondary) }
                    ForEach(videos) { video in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(video.title).font(.headline)
                            Text("\(video.id) · \(video.duration)s · \(video.availability.rawValue)").font(.caption)
                            if case .unknown = video.availability { Text("Unsupported status — playback unavailable").font(.caption).foregroundStyle(.orange) }
                            Text(video.tags.isEmpty ? "No tags" : video.tags.joined(separator: ", ")).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
                Section("2 · Persist deliberately") {
                    Button("Save current library to disk") {
                        do {
                            try cache.save(videos)
                            json = String(decoding: try Data(contentsOf: cache.url), as: UTF8.self)
                            message = "Saved version 2 to Documents."
                        } catch { message = decodingDiagnostic(error) }
                    }.disabled(videos.isEmpty)
                    Button("Restore saved library") {
                        do {
                            let replacement = try cache.load()
                            videos = replacement
                            message = "Restored \(videos.count) videos from disk."
                        } catch { message = decodingDiagnostic(error) }
                    }
                    Button("Import legacy version 1 fixture") {
                        do {
                            let replacement = try decodeCache(Data(legacyCache.utf8))
                            videos = replacement
                            message = "Migrated in memory. Save to write version 2."
                        } catch { message = decodingDiagnostic(error) }
                    }
                    Button("Try unsupported version 99") {
                        do { videos = try decodeCache(Data(#"{"version":99,"videos":[]}"#.utf8)) }
                        catch { message = decodingDiagnostic(error) }
                    }
                    if !json.isEmpty {
                        DisclosureGroup("Last saved JSON") { Text(json).font(.system(.caption, design: .monospaced)).textSelection(.enabled) }
                    }
                }
                Section("Result") { Text(message).accessibilityIdentifier("result") }
                Section { Text("Local fixtures, real Codable and disk storage. No server request is made. Small teaching payloads run synchronously.").font(.footnote).foregroundStyle(.secondary) }
            }.navigationTitle("Library Sync")
        }
    }
}
