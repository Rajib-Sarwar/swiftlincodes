let raw = ["2", "urgent", "0", "4", "3"]
func validPriority(_ text: String) -> Int? {
    guard let value = Int(text), (0...3).contains(value) else { return nil }
    return value
}
// TODO: Keep one optional result per input, then collect only valid priorities.
let positions: [Int?] = []
let accepted: [Int] = []
print(positions.map { $0.map(String.init) ?? "nil" }.joined(separator: ","))
print(accepted)
