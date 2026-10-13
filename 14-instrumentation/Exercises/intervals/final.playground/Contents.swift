enum Event { case begin(String, Int), end(String, Int) }
func intervals(_ events: [Event]) -> [String] {
    var active: [String: Int] = [:]
    var output: [String] = []
    for event in events {
        switch event {
        case .begin(let id, let time):
            if time >= 0 && active[id] == nil { active[id] = time }
        case .end(let id, let time):
            guard let start = active[id], time >= start else { continue }
            output.append("\(id):\(time - start)")
            active.removeValue(forKey: id)
        }
    }
    return output
}
print(intervals([.begin("A", 10), .begin("B", 12), .end("A", 15), .end("B", 20), .end("A", 30)]))
