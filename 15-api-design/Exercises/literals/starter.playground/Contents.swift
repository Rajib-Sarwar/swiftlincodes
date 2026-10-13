struct SavedTags: ExpressibleByArrayLiteral {
    let values: [String]
    init(arrayLiteral elements: String...) {
        // TODO: Keep the first occurrence of each exact string.
        values = elements
    }
}
let tags: SavedTags = ["offline", "swift", "offline", "Swift"]
print(tags.values)
let empty: SavedTags = []
print(empty.values.count)
