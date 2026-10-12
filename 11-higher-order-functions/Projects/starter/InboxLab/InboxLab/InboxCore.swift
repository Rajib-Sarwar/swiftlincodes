struct Notice: Equatable, Identifiable, Sendable {
    let id: Int
    let title: String
    let category: String
    let priority: Int
    let isRead: Bool
    let tags: [String]
}

let sampleNotices: [Notice] = [
    Notice(id: 3, title: "Build ready", category: "work", priority: 2, isRead: false, tags: ["build", "ios"]),
    Notice(id: 1, title: "Review requested", category: "work", priority: 2, isRead: false, tags: ["ios"]),
    Notice(id: 2, title: "Welcome", category: "social", priority: 1, isRead: true, tags: []),
    Notice(id: 4, title: "New message", category: "social", priority: 3, isRead: false, tags: ["chat"])
]

struct InboxOptions: Equatable, Sendable {
    var unreadOnly = true
    var minimumPriority = 0
    var category: String? = nil
}

// A policy factory: returned closures capture the value of options for this call.
func makeRule(_ options: InboxOptions) -> (Notice) -> Bool {
    // TODO 1: Return a predicate that combines all three options.
    { _ in true }
}

// Priority descending, then ID ascending. No subtraction and no >= comparison.
func comesBefore(_ lhs: Notice, _ rhs: Notice) -> Bool {
    // TODO 2: Sort by priority descending, then ID ascending.
    return false
}

func visibleNotices(_ notices: [Notice], options: InboxOptions) -> [Notice] {
    // TODO 3: Filter, then order the retained notifications.
    return notices
}

func categoryCounts(_ notices: [Notice]) -> [String: Int] {
    // TODO 4: Count the given (already visible) rows by category.
    return [:]
}

func rowTitles(_ notices: [Notice]) -> [String] {
    notices.map { "[\($0.priority)] \($0.title)" }
}

struct RawNotice: Sendable {
    let id: Int
    let title: String
    let category: String
    let priorityText: String
    let isRead: Bool
    let tags: [String]
}
struct ImportReport: Sendable {
    var accepted: [Notice] = []
    var rejectedIDs: [Int] = []
}
// The fixture contract has unique IDs. This importer reports invalid priorities;
// it does not claim to validate a complete production notification payload.
func importNotices(_ rows: [RawNotice]) -> ImportReport {
    rows.reduce(into: ImportReport()) { report, row in
        guard let priority = Int(row.priorityText), (0...3).contains(priority) else {
            report.rejectedIDs.append(row.id)
            return
        }
        report.accepted.append(Notice(id: row.id, title: row.title, category: row.category,
            priority: priority, isRead: row.isRead, tags: row.tags))
    }
}
let sampleRows: [RawNotice] = sampleNotices.map {
    RawNotice(id: $0.id, title: $0.title, category: $0.category,
        priorityText: String($0.priority), isRead: $0.isRead, tags: $0.tags)
} + [RawNotice(id: 5, title: "Bad priority", category: "work", priorityText: "urgent", isRead: false, tags: [])]
