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

for range in ChunkRanges(total: 10, size: 4) { print(range) }
