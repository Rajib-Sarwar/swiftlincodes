struct Notice {
    let category: String
    let isRead: Bool
}
func unreadCounts(_ notices: [Notice]) -> [String: Int] {
    notices.reduce(into: [:]) { counts, notice in
        if !notice.isRead { counts[notice.category, default: 0] += 1 }
    }
}
let rows = [Notice(category: "work", isRead: false), Notice(category: "social", isRead: true), Notice(category: "work", isRead: false), Notice(category: "social", isRead: false)]
let counts = unreadCounts(rows)
for key in counts.keys.sorted() { print("\(key): \(counts[key]!)") }
print(unreadCounts([]).count)
