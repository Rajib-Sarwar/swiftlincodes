import Foundation
struct LegacyFields { let title: String; let body: String? }
func labels(_ fields: LegacyFields) -> [String] {
    // TODO: Trim title; blank becomes Untitled. Only nil body becomes No preview.
    return []
}
print(labels(LegacyFields(title: "  Welcome  ", body: nil)))
print(labels(LegacyFields(title: " ", body: "")))
