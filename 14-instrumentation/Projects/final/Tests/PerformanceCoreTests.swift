import Foundation
import Testing
@testable import PerformanceCore

@Test func countsPreserveOrderAndDuplicates() {
    #expect(candidateCounts([2, 1, 2, 3, 1]) == [2, 2, 2, 1, 2])
}
@Test func emptyCounts() { #expect(candidateCounts([]).isEmpty) }
@Test func negativeAndIdenticalTags() {
    #expect(candidateCounts([-1, -1, -1]) == [3, 3, 3])
}
@Test func candidateMatchesBaseline() {
    let input = (0..<257).map { ($0 * 17) % 19 }
    #expect(candidateCounts(input) == baselineCounts(input))
}
@Test func durationUnits() {
    #expect(milliseconds(.milliseconds(1250)) == 1250)
    #expect(abs(milliseconds(.microseconds(750)) - 0.75) < 0.000001)
}
@Test func medians() {
    #expect(median([9, 1, 5]) == 5)
    #expect(median([8, 2, 4, 6]) == 5)
    #expect(median([]) == nil)
    #expect(median([.nan]) == nil)
    #expect(median([-1, 2]) == nil)
}
@Test func reportsConsumeEquivalentOutput() {
    let a = measureCounts([1, 2, 1], candidate: false, repeats: 2)
    let b = measureCounts([1, 2, 1], candidate: true, repeats: 2)
    #expect(a.checksum == 5 && b.checksum == 5)
    #expect(a.samples.count == 2 && b.samples.count == 2)
    #expect(a.samples.allSatisfy { $0.isFinite && $0 >= 0 })
    // No timing threshold: a loaded test machine must not fail a correctness check.
}
@Test func callbackWorksWhileOwnerExists() {
    let session = PreviewSession(); session.installCallback(); session.onRefresh?()
    #expect(session.refreshes == 1)
}
@Test func sessionReleasesAfterOwnerLeaves() {
    weak var observed: PreviewSession?
    do { let session = PreviewSession(); session.installCallback(); observed = session }
    let released = observed == nil
    observed?.onRefresh = nil // Clean the intentionally broken starter after collecting evidence.
    #expect(released)
}
@Test func previewBoundsAndAspectRatio() throws {
    let data = try makeImageFixture(width: 800, height: 600)
    let image = try decodePreview(data, maxPixelSize: 160)
    #expect(image.width <= 160 && image.height <= 160)
    #expect(abs(Double(image.width) / Double(image.height) - 4.0 / 3.0) < 0.02)
}
@Test func invalidImageData() {
    #expect(throws: (any Error).self) { _ = try decodePreview(Data(), maxPixelSize: 160) }
}
@Test func invalidImageSize() {
    #expect(throws: (any Error).self) { _ = try decodePreview(Data(), maxPixelSize: 0) }
}
