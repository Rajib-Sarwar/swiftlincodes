func ownedLabels() -> [String] {
    let pointer = UnsafeMutablePointer<String>.allocate(capacity: 2)
    pointer.initialize(repeating: "pending", count: 2)
    defer {
        pointer.deinitialize(count: 2)
        pointer.deallocate()
    }
    pointer[0] = "received"
    pointer[1] = "validated"
    return Array(UnsafeBufferPointer(start: pointer, count: 2))
}
print(ownedLabels())
