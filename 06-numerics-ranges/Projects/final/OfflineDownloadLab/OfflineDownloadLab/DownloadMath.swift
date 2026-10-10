enum DownloadMath {
    // Unknown or inconsistent measurements have no determinate progress.
    static func progress(completed: Int, total: Int?) -> Double? {
        guard let total, total > 0, completed >= 0, completed <= total else { return nil }
        return Double(completed) / Double(total)
    }

    // This boundary receives a floating-point measurement, not a text file size.
    static func byteCount(from value: Double) -> Int? {
        guard let count = Int(exactly: value), count >= 0 else { return nil }
        return count
    }

    static func nextChunk(from start: Int, total: Int, size: Int) -> Range<Int>? {
        guard total >= 0, size > 0, start >= 0, start < total else { return nil }
        // Subtract first: start + size could overflow before min could clamp it.
        let length = min(size, total - start)
        return start..<(start + length)
    }
}
