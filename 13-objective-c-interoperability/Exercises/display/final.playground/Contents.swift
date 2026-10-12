import Foundation
struct LegacyFields { let title: String; let body: String? }
func labels(_ fields: LegacyFields) -> [String] {
    let clean = fields.title.trimmingCharacters(in: .whitespacesAndNewlines)
    return [clean.isEmpty ? "Untitled" : clean, fields.body ?? "No preview"]
}
print(labels(LegacyFields(title: "  Welcome  ", body: nil)))
print(labels(LegacyFields(title: " ", body: "")))
