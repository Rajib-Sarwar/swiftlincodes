enum Input { case query(String), online(Bool) }
func trace(_ events: [Input]) -> [Bool] {
    var query: String?; var online: Bool?; var output: [Bool] = []
    for event in events {
        switch event {
        case .query(let value): query = value
        case .online(let value): online = value
        }
        if let query, let online { output.append(query.count >= 2 && online) }
    }
    return output
}
print(trace([.query("sw"), .online(true), .query("s"), .online(false), .query("swift"), .online(true)]))
