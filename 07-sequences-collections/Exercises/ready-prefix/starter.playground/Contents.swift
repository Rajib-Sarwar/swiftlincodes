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
func firstReadyTitles<S: Sequence>(_ videos: S, limit: Int) -> [String] where S.Element == Video {
    // TODO: Read at most as far as the requested matching result.
    return []
}

print(firstReadyTitles(sampleVideos, limit: 2))
print(firstReadyTitles(sampleVideos, limit: 0))
