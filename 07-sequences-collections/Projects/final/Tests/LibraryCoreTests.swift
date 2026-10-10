import Testing
@testable import LibraryCore

@Test func iteratorIndependenceAndExhaustion() {
    let plan = ChunkRanges(total: 10, size: 4)
    #expect(Array(plan) == [0..<4, 4..<8, 8..<10])
    var a = plan.makeIterator(), b = plan.makeIterator()
    #expect(a.next() == 0..<4)
    #expect(a.next() == 4..<8)
    #expect(b.next() == 0..<4)
    _ = a.next()
    #expect(a.next() == nil)
    #expect(a.next() == nil)
    #expect(Array(ChunkRanges(total: 0, size: 4)).isEmpty)
    #expect(Array(ChunkRanges(total: 4, size: 0)).isEmpty)
    #expect(Array(ChunkRanges(total: -1, size: 4)).isEmpty)
    #expect(Array(ChunkRanges(total: Int.max, size: Int.max)) == [0..<Int.max])
}
@Test func batchContracts() throws {
    let values = [10,20,30,40,50]
    let groups = try batches(values[1...], size: 3)
    #expect(groups.map(Array.init) == [[20,30,40],[50]])
    #expect(groups.first?.startIndex == 1)
    #expect(try batches([Int](), size: 3).isEmpty)
    #expect(try batches(values, size: 99).map(Array.init) == [values])
    #expect(throws: LibraryError.self) { try batches(values, size: 0) }
    #expect(throws: LibraryError.self) { try batches(values, size: -1) }
    #expect(try batches("A👨‍👩‍👧‍👦éB", size: 2).map(String.init) == ["A👨‍👩‍👧‍👦", "éB"])
}
@Test func batchCoverage() throws {
    for count in 0...30 {
        let source = Array(0..<count)
        for size in 1...8 {
            let groups = try batches(source, size: size)
            #expect(groups.flatMap(Array.init) == source)
            #expect(groups.allSatisfy { !$0.isEmpty && $0.count <= size })
        }
    }
}
// A sequence whose makeIterator returns the same consuming source.
final class OneShot: Sequence, IteratorProtocol {
    private var iterator = sampleVideos.makeIterator()
    private(set) var reads = 0
    func makeIterator() -> OneShot { self }
    func next() -> Video? { reads += 1; return iterator.next() }
}
@Test func boundedSinglePass() {
    let source = OneShot()
    #expect(firstReadyTitles(source, limit: 2) == ["Swift types", "Generics"])
    #expect(source.reads == 3)
    let untouched = OneShot()
    #expect(firstReadyTitles(untouched, limit: 0).isEmpty)
    #expect(firstReadyTitles(untouched, limit: -1).isEmpty)
    #expect(untouched.reads == 0)
    #expect(firstReadyTitles(sampleVideos, limit: 99) == ["Swift types", "Generics", "Numerics"])
    #expect(firstReadyTitles([Video](), limit: 2).isEmpty)
    #expect(firstReadyTitles(sampleVideos.filter { !$0.isDownloaded }, limit: 2).isEmpty)
}
@Test func snapshotValueSemantics() {
    let original = sampleVideos
    var draft = original
    draft[0].isDownloaded = false
    #expect(original[0].isDownloaded)
    #expect(!draft[0].isDownloaded)
}
