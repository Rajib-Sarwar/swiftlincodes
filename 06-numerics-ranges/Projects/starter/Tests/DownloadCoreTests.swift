import Testing
@testable import DownloadCore

@Test func progressPolicy() {
    #expect(DownloadMath.progress(completed: 250, total: 1000) == 0.25)
    #expect(DownloadMath.progress(completed: 0, total: 100) == 0)
    #expect(DownloadMath.progress(completed: 100, total: 100) == 1)
    for total: Int? in [nil, 0, -1] { #expect(DownloadMath.progress(completed: 0, total: total) == nil) }
    #expect(DownloadMath.progress(completed: -1, total: 100) == nil)
    #expect(DownloadMath.progress(completed: 101, total: 100) == nil)
}
@Test func exactConversion() {
    #expect(DownloadMath.byteCount(from: 0) == 0)
    #expect(DownloadMath.byteCount(from: 1024) == 1024)
    for value in [1.5, -1, Double.nan, .infinity, -.infinity, .greatestFiniteMagnitude] {
        #expect(DownloadMath.byteCount(from: value) == nil)
    }
}
@Test func coverage() {
    for total in 0...50 {
        for size in 1...12 {
            var start = 0
            var bytes: [Int] = []
            while let chunk = DownloadMath.nextChunk(from: start, total: total, size: size) {
                #expect(!chunk.isEmpty && chunk.count <= size)
                bytes.append(contentsOf: chunk)
                start = chunk.upperBound
                if bytes.count > total { Issue.record("Plan did not terminate"); break }
            }
            #expect(bytes == Array(0..<total))
        }
    }
}
@Test func invalidAndExtremeBoundaries() {
    #expect(DownloadMath.nextChunk(from: 0, total: 10, size: 0) == nil)
    #expect(DownloadMath.nextChunk(from: -1, total: 10, size: 4) == nil)
    #expect(DownloadMath.nextChunk(from: 0, total: -1, size: 4) == nil)
    #expect(DownloadMath.nextChunk(from: 10, total: 10, size: 4) == nil)
    #expect(DownloadMath.nextChunk(from: Int.max - 2, total: Int.max, size: 10) == (Int.max - 2)..<Int.max)
}
