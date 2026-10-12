import Foundation
enum Issue: Equatable {
    case invalidTitle, missingNote, other(String, Int)
}
func translate(_ error: NSError) -> Issue {
    guard error.domain == "com.swiftlin.LegacyNotes" else { return .other(error.domain, error.code) }
    switch error.code {
    case 1: return .invalidTitle
    case 2: return .missingNote
    default: return .other(error.domain, error.code)
    }
}
let errors = [NSError(domain: "com.swiftlin.LegacyNotes", code: 1),
              NSError(domain: "com.swiftlin.LegacyNotes", code: 2),
              NSError(domain: "OtherSDK", code: 1),
              NSError(domain: "com.swiftlin.LegacyNotes", code: 99)]
print(errors.map(translate) == [.invalidTitle, .missingNote, .other("OtherSDK", 1), .other("com.swiftlin.LegacyNotes", 99)])
