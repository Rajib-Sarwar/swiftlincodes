enum SaveOutcome { case inserted, alreadySaved, full }
struct SavedItems {
    private(set) var ids: [String] = []
    let capacity: Int
    mutating func insert(_ id: String) -> SaveOutcome {
        // TODO: Preserve the stated outcome and ordering contract.
        return .full
    }
}
var saved = SavedItems(capacity: 1)
print(saved.insert("A"))
print(saved.insert("A"))
print(saved.insert("B"))
print(saved.ids)
