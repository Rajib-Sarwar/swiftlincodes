import Foundation
var checks = 0
var failures = 0
@MainActor
func check(_ condition: @autoclosure () -> Bool, _ name: String) {
    checks += 1
    if condition() { print("PASS: \(name)") }
    else { failures += 1; print("FAIL: \(name)") }
}
let store = SLNoteStore()
let adapter = NotesAdapter(store: store)
check(adapter.count == 2, "refined Objective-C count")
let initial = adapter.rows()
check(initial.map(\.id) == ["welcome", "draft"], "typed array preserves stable identifiers")
check(initial.map(\.title) == ["Welcome", "Untitled"], "trim and fallback")
check(initial[0].body == "No preview", "nullable body becomes explicit fallback")
check(initial[0].badge == "Pinned", "enum maps pinned")
check(initial[1].badge == "Note", "enum maps plain")
let emptyBody = SLNote(identifier: "empty", title: "", body: "", kind: .plain)
check(NoteRow(emptyBody).body == "", "empty body is not nil")
let oldObject = store.notes()[0]
try adapter.rename(id: "welcome", title: "  Updated  ")
check(adapter.rows()[0].title == "Updated", "Swift calls throwing Objective-C method")
check(oldObject.title == "Updated", "NSArray copy still shares note references")
check(initial[0].title == "Welcome", "Swift value snapshot does not change")
do { try adapter.rename(id: "welcome", title: " \n "); check(false, "blank must throw") }
catch { check(error as? NoteIssue == .invalidTitle, "NSError translates to invalid title") }
check(adapter.rows()[0].title == "Updated", "failed rename preserves stored title")
do { try adapter.rename(id: "absent", title: "Test"); check(false, "missing must throw") }
catch { check(error as? NoteIssue == .missingNote, "NSError translates to missing note") }
check(noteIssue(NSError(domain: "other", code: 1)) == .other(domain: "other", code: 1), "domain participates in error identity")
check(noteIssue(NSError(domain: SLNoteErrorDomain, code: 99)) == .other(domain: SLNoteErrorDomain, code: 99), "unknown code is retained")
check(SLLegacyPreview(emptyBody) == "Legacy preview: Untitled", "Objective-C calls generated Swift selector")
try adapter.rename(id: "welcome", title: "Recovered")
check(adapter.rows()[0].title == "Recovered", "save succeeds after failure")
print("\(checks - failures)/\(checks) checks passed")
if failures > 0 { exit(1) }
