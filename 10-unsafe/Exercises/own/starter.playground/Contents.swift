func ownedLabels() -> [String] {
    let pointer = UnsafeMutablePointer<String>.allocate(capacity: 2)
    pointer.initialize(repeating: "pending", count: 2)
    defer {
        pointer.deinitialize(count: 2)
        pointer.deallocate()
    }
    // TODO: Update both initialized slots and copy them into an owned Array.
    return []
}
print(ownedLabels())
