func decodedBytes(width: Int, height: Int, count: Int) -> Int? {
    guard width >= 0, height >= 0, count >= 0 else { return nil }
    if width == 0 || height == 0 || count == 0 { return 0 }
    let (pixels, a) = width.multipliedReportingOverflow(by: height)
    let (bytes, b) = pixels.multipliedReportingOverflow(by: 4)
    let (total, c) = bytes.multipliedReportingOverflow(by: count)
    return a || b || c ? nil : total
}
print(decodedBytes(width: 4096, height: 3072, count: 2) ?? -1)
print(decodedBytes(width: Int.max, height: 2, count: 1) == nil)
print(decodedBytes(width: 10, height: 10, count: 0) ?? -1)
