enum Event { case started(Int), succeeded(Int, String), failed(Int), cleared }
func trace(_ events: [Event]) -> [String] {
    var active: Int?; var output: [String] = []
    for event in events {
        switch event {
        case .started(let id): active = id; output.append("loading")
        case .succeeded(let id, let value):
            if active == id { output.append(value); active = nil }
        case .failed(let id):
            if active == id { output.append("failed"); active = nil }
        case .cleared: active = nil; output.append("idle")
        }
    }
    return output
}
print(trace([.started(1), .started(2), .succeeded(1,"old"), .failed(2), .started(3), .succeeded(3,"new"), .cleared, .succeeded(3,"late")]))
