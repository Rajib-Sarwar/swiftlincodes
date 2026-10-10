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

for range in ChunkRanges(total: 10, size: 4) { print(range) }
