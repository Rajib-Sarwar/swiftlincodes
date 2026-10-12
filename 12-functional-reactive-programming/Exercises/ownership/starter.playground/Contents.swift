enum Event { case started(Int), succeeded(Int, String), failed(Int), cleared }
func trace(_ events: [Event]) -> [String] {
    // TODO: Only the current request may publish success/failure. Clearing invalidates it.
    return []
}
print(trace([.started(1), .started(2), .succeeded(1,"old"), .failed(2), .started(3), .succeeded(3,"new"), .cleared, .succeeded(3,"late")]))
