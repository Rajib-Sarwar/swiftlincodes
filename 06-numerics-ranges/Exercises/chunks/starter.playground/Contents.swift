enum DownloadMath {
    static func nextChunk(from start: Int, total: Int, size: Int) -> Range<Int>? {
        // TODO: Validate, calculate a safe length, and return a half-open range.
        return nil
    }
}
var start = 0
while let chunk = DownloadMath.nextChunk(from: start, total: 10, size: 4) {
    print("\(chunk.lowerBound)..<\(chunk.upperBound)")
    start = chunk.upperBound
}
