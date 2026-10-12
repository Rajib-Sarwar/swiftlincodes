enum Input { case query(String), online(Bool) }
func trace(_ events: [Input]) -> [Bool] {
    // TODO: Wait until both inputs have values, then emit eligibility on every change.
    return []
}
print(trace([.query("sw"), .online(true), .query("s"), .online(false), .query("swift"), .online(true)]))
