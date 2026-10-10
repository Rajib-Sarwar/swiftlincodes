enum LibraryError: Error { case invalidBatchSize }

func batches<C: Collection>(_ values: C, size: Int) throws -> [C.SubSequence] {
    guard size > 0 else { throw LibraryError.invalidBatchSize }
    // TODO: Walk collection indices and append subsequences.
    return []
}

let values = [10, 20, 30, 40, 50]
for group in try batches(values[1...], size: 3) { print(Array(group)) }
print(try batches("Swift", size: 2).map(String.init))
