import Foundation
func normalizedChanges(_ events: [String]) -> [String] {
    // TODO: Trim and lowercase, then suppress consecutive equivalents. Keep empty changes.
    return []
}
print(normalizedChanges([" Sw ", "sw", "Swift", " ", "", "swift"]))
