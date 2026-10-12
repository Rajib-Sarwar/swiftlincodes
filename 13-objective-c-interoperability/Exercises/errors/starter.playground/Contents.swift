import Foundation
enum Issue: Equatable {
    case invalidTitle, missingNote, other(String, Int)
}
func translate(_ error: NSError) -> Issue {
    // TODO: Domain com.swiftlin.LegacyNotes: code 1 invalidTitle, code 2 missingNote.
    return .other(error.domain, error.code)
}
let errors = [NSError(domain: "com.swiftlin.LegacyNotes", code: 1),
              NSError(domain: "com.swiftlin.LegacyNotes", code: 2),
              NSError(domain: "OtherSDK", code: 1),
              NSError(domain: "com.swiftlin.LegacyNotes", code: 99)]
print(errors.map(translate) == [.invalidTitle, .missingNote, .other("OtherSDK", 1), .other("com.swiftlin.LegacyNotes", 99)])
