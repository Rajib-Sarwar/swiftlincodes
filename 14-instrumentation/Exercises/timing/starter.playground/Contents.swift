func milliseconds(_ duration: Duration) -> Double {
    let c = duration.components
    return Double(c.seconds) * 1000 + Double(c.attoseconds) / 1_000_000_000_000_000
}
func medianMilliseconds(_ samples: [Duration]) -> Double? {
    // TODO: Reject empty or negative samples; sort values and calculate the median.
    return nil
}
print(medianMilliseconds([.milliseconds(100), .milliseconds(10), .milliseconds(14), .milliseconds(20)]) ?? -1)
print(medianMilliseconds([.microseconds(750)]) ?? -1)
print(medianMilliseconds([]) == nil)
