import Testing
@testable import InboxCore

@Test func defaultInbox() {
    #expect(visibleNotices(sampleNotices, options: InboxOptions()).map(\.id) == [4, 1, 3])
}
@Test func filtersCombine() {
    let o = InboxOptions(unreadOnly: true, minimumPriority: 2, category: "work")
    #expect(visibleNotices(sampleNotices, options: o).map(\.id) == [1, 3])
}
@Test func includeReadAndEmpty() {
    #expect(visibleNotices(sampleNotices, options: InboxOptions(unreadOnly: false)).map(\.id) == [4, 1, 3, 2])
    #expect(visibleNotices([], options: InboxOptions()).isEmpty)
    #expect(visibleNotices(sampleNotices, options: InboxOptions(category: "missing")).isEmpty)
}
@Test func boundaryPriority() {
    #expect(visibleNotices(sampleNotices, options: InboxOptions(minimumPriority: 2)).map(\.id) == [4, 1, 3])
    #expect(visibleNotices(sampleNotices, options: InboxOptions(minimumPriority: 3)).map(\.id) == [4])
}
@Test func countsUseVisibleRows() {
    let rows = visibleNotices(sampleNotices, options: InboxOptions())
    #expect(categoryCounts(rows) == ["work": 2, "social": 1])
    #expect(categoryCounts([sampleNotices[0], sampleNotices[0]]) == ["work": 2])
    #expect(categoryCounts([]).isEmpty)
}
@Test func comparatorLaws() {
    for a in sampleNotices {
        #expect(!comesBefore(a, a))
        for b in sampleNotices {
            if comesBefore(a, b) { #expect(!comesBefore(b, a)) }
            for c in sampleNotices where comesBefore(a, b) && comesBefore(b, c) {
                #expect(comesBefore(a, c))
            }
        }
    }
}
@Test func shuffledInputSameOrder() {
    let o = InboxOptions(unreadOnly: false)
    #expect(visibleNotices(Array(sampleNotices.reversed()), options: o).map(\.id) == [4, 1, 3, 2])
}
@Test func capturesOptionsSnapshot() {
    var options = InboxOptions(minimumPriority: 3)
    let oldRule = makeRule(options)
    options.minimumPriority = 0
    #expect(!oldRule(sampleNotices[0]))
    #expect(makeRule(options)(sampleNotices[0]))
}
@Test func importRetainsFailures() {
    let report = importNotices(sampleRows)
    #expect(report.accepted == sampleNotices)
    #expect(report.rejectedIDs == [5])
    let values = ["-1", "4", "bad", "999999999999999999999999999999", "0", "3"]
    let rows = values.enumerated().map { i, p in
        RawNotice(id: i, title: "Test", category: "work", priorityText: p, isRead: false, tags: [])
    }
    #expect(importNotices(rows).rejectedIDs == [0, 1, 2, 3])
    #expect(importNotices(rows).accepted.map(\.priority) == [0, 3])
    #expect(importNotices([]).accepted.isEmpty)
}
@Test func transformPreservesOrderAndInput() {
    let before = sampleNotices
    #expect(rowTitles(visibleNotices(sampleNotices, options: InboxOptions())) == ["[3] New message", "[2] Review requested", "[2] Build ready"])
    #expect(sampleNotices == before)
    #expect(rowTitles([]).isEmpty)
}
