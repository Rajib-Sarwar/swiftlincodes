func decodedBytes(width: Int, height: Int, count: Int) -> Int? {
    // TODO: Reject negative inputs and overflow. Zero inputs are valid and return zero.
    return nil
}
print(decodedBytes(width: 4096, height: 3072, count: 2) ?? -1)
print(decodedBytes(width: Int.max, height: 2, count: 1) == nil)
print(decodedBytes(width: 10, height: 10, count: 0) ?? -1)
