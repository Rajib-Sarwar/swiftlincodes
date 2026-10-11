import Foundation

enum Fixture: String, CaseIterable, Identifiable {
    case valid = "Valid response"
    case missingTags = "Missing tags"
    case nullTags = "Null tags"
    case wrongDuration = "Wrong duration type"
    case duplicate = "Duplicate ID"
    case invalidDate = "Invalid date"
    var id: String { rawValue }
    var json: String {
        let valid = #"{"metadata":{"updated_at":"2026-10-11T12:00:00Z"},"videos":[{"id":"v1","title":"Café","summary":null,"duration_seconds":"90","availability":"ready","tags":["swift"]},{"id":"v2","title":"Unicode 👩🏽‍💻","duration_seconds":"120","availability":"scheduled"}]}"#
        switch self {
        case .valid: return valid
        case .missingTags: return valid.replacingOccurrences(of: #","tags":["swift"]"#, with: "")
        case .nullTags: return valid.replacingOccurrences(of: #""tags":["swift"]"#, with: #""tags":null"#)
        case .wrongDuration: return valid.replacingOccurrences(of: #""duration_seconds":"90""#, with: #""duration_seconds":90"#)
        case .duplicate: return valid.replacingOccurrences(of: #""id":"v2""#, with: #""id":"v1""#)
        case .invalidDate: return valid.replacingOccurrences(of: "2026-10-11T12:00:00Z", with: "yesterday")
        }
    }
}
let legacyCache = #"{"version":1,"videos":[{"id":"old1","title":"Legacy lesson","duration":60}]}"#
