struct Notice {
    let category: String
    let isRead: Bool
}
func unreadCounts(_ notices: [Notice]) -> [String: Int] {
    // TODO: Build counts for unread notifications, without listing zero-count categories.
    return [:]
}
let rows = [Notice(category: "work", isRead: false), Notice(category: "social", isRead: true), Notice(category: "work", isRead: false), Notice(category: "social", isRead: false)]
let counts = unreadCounts(rows)
for key in counts.keys.sorted() { print("\(key): \(counts[key]!)") }
print(unreadCounts([]).count)
