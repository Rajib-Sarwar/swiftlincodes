import Foundation
func normalizedChanges(_ events: [String]) -> [String] {
    var output: [String] = []
    for event in events {
        let value = event.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if output.last != value { output.append(value) }
    }
    return output
}
print(normalizedChanges([" Sw ", "sw", "Swift", " ", "", "swift"]))
