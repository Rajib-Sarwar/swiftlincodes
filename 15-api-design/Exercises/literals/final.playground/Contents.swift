struct SavedTags: ExpressibleByArrayLiteral {
    let values: [String]
    init(arrayLiteral elements: String...) {
        var seen = Set<String>()
        values = elements.filter { seen.insert($0).inserted }
    }
}
let tags: SavedTags = ["offline", "swift", "offline", "Swift"]
print(tags.values)
let empty: SavedTags = []
print(empty.values.count)
