enum SaveOutcome { case inserted, alreadySaved, full }
struct SavedItems {
    private(set) var ids: [String] = []
    let capacity: Int
    mutating func insert(_ id: String) -> SaveOutcome {
        if ids.contains(id) { return .alreadySaved }
        guard ids.count < capacity else { return .full }
        ids.append(id)
        return .inserted
    }
}
var saved = SavedItems(capacity: 1)
print(saved.insert("A"))
print(saved.insert("A"))
print(saved.insert("B"))
print(saved.ids)
