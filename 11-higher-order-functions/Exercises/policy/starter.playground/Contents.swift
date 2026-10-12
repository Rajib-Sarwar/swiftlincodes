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

func minimumPriority(_ value: Int) -> (Notice) -> Bool {
    // TODO: Capture value in a predicate that includes the boundary.
    return { _ in false }
}
func comesBefore(_ a: Notice, _ b: Notice) -> Bool {
    // TODO: Priority descending; ties by ascending ID.
    return false
}
let selected = sampleNotices.filter(minimumPriority(2)).sorted(by: comesBefore)
print(selected.map(\.id))
print(sampleNotices.map(\.id))
print(comesBefore(sampleNotices[0], sampleNotices[0]))
