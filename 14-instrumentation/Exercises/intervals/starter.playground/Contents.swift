enum Event { case begin(String, Int), end(String, Int) }
func intervals(_ events: [Event]) -> [String] {
    // TODO: Pair by ID; output id:duration in completion order. Times are nonnegative milliseconds.
    // Ignore duplicate begins while active, unmatched ends, and ends earlier than their start.
    return []
}
print(intervals([.begin("A", 10), .begin("B", 12), .end("A", 15), .end("B", 20), .end("A", 30)]))
