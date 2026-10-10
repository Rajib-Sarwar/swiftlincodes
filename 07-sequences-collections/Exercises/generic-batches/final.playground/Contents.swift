enum LibraryError: Error { case invalidBatchSize }

func batches<C: Collection>(_ values: C, size: Int) throws -> [C.SubSequence] {
    guard size > 0 else { throw LibraryError.invalidBatchSize }
    var result: [C.SubSequence] = []
    var start = values.startIndex
    while start != values.endIndex {
        let end = values.index(start, offsetBy: size, limitedBy: values.endIndex) ?? values.endIndex
        result.append(values[start..<end])
        start = end
    }
    return result
}

let values = [10, 20, 30, 40, 50]
for group in try batches(values[1...], size: 3) { print(Array(group)) }
print(try batches("Swift", size: 2).map(String.init))
