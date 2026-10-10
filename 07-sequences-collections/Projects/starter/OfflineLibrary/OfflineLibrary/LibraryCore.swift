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
            // TODO: Return the next bounded range and advance position.
            return nil
        }
    }
    func makeIterator() -> Iterator { Iterator(total: total, size: size) }
}

enum LibraryError: Error { case invalidBatchSize }

func batches<C: Collection>(_ values: C, size: Int) throws -> [C.SubSequence] {
    guard size > 0 else { throw LibraryError.invalidBatchSize }
    // TODO: Walk collection indices and append subsequences.
    return []
}

func firstReadyTitles<S: Sequence>(_ videos: S, limit: Int) -> [String] where S.Element == Video {
    // TODO: Read at most as far as the requested matching result.
    return []
}
