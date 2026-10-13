func milliseconds(_ duration: Duration) -> Double {
    let c = duration.components
    return Double(c.seconds) * 1000 + Double(c.attoseconds) / 1_000_000_000_000_000
}
func medianMilliseconds(_ samples: [Duration]) -> Double? {
    guard !samples.isEmpty, samples.allSatisfy({ $0 >= .zero }) else { return nil }
    let sorted = samples.map(milliseconds).sorted()
    let middle = sorted.count / 2
    return sorted.count.isMultiple(of: 2) ? sorted[middle - 1] / 2 + sorted[middle] / 2 : sorted[middle]
}
print(medianMilliseconds([.milliseconds(100), .milliseconds(10), .milliseconds(14), .milliseconds(20)]) ?? -1)
print(medianMilliseconds([.microseconds(750)]) ?? -1)
print(medianMilliseconds([]) == nil)
