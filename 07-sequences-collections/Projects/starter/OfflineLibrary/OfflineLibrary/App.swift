import SwiftUI

@main
struct OfflineLibraryApp: App {
    var body: some Scene { WindowGroup { LibraryView() } }
}
struct LibraryView: View {
    @State private var videos = sampleVideos
    @State private var saved = sampleVideos
    @State private var batchSize = 2
    @State private var page = 0
    private var groups: [[Video]] {
        // Own the displayed groups rather than retaining slices at this UI boundary.
        ((try? batches(videos, size: batchSize)) ?? []).map(Array.init)
    }
    var body: some View {
        NavigationStack {
            List {
                Section("Ready to watch · first two") {
                    let titles = firstReadyTitles(videos, limit: 2)
                    if titles.isEmpty { Text("No ready titles yet") }
                    ForEach(Array(titles.enumerated()), id: \.offset) { _, title in Text(title) }
                }
                Section("Browse the library") {
                    Picker("Batch size", selection: $batchSize) {
                        ForEach(1...3, id: \.self) { Text(String($0)).tag($0) }
                    }.onChange(of: batchSize) { _, _ in page = 0 }
                    if groups.indices.contains(page) {
                        ForEach(groups[page]) { video in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(video.title).font(.headline)
                                Text(video.isDownloaded ? "Available offline" : "Not downloaded").font(.caption)
                                Button(video.isDownloaded ? "Remove download" : "Mark downloaded") {
                                    if let index = videos.firstIndex(where: { $0.id == video.id }) {
                                        videos[index].isDownloaded.toggle()
                                    }
                                }
                                Text("Chunk plan: " + ChunkRanges(total: video.bytes, size: 4).map { "\($0.lowerBound)..<\($0.upperBound)" }.joined(separator: ", "))
                                    .font(.system(.caption, design: .monospaced))
                            }
                        }
                    } else { Text("No batches yet. Complete the helper in LibraryCore.swift.") }
                    HStack {
                        Button("Previous") { page -= 1 }.disabled(page == 0)
                        Spacer()
                        Text(groups.isEmpty ? "0 / 0" : "\(page + 1) / \(groups.count)")
                        Spacer()
                        Button("Next") { page += 1 }.disabled(page + 1 >= groups.count)
                    }
                }
                Section("Try a value snapshot") {
                    Text("Saved downloads: \(saved.filter { $0.isDownloaded }.count). Current downloads: \(videos.filter { $0.isDownloaded }.count).")
                    Button("Save snapshot") { saved = videos }
                    Button("Restore snapshot") { videos = saved; page = 0 }
                    Button("Reset sample library") { videos = sampleVideos; saved = sampleVideos; page = 0 }
                    Text("Change a download after saving. The saved array stays unchanged because Video is a value type. No files are downloaded; these are local fixtures.").font(.caption)
                }
            }.navigationTitle("Offline Library")
        }
    }
}
