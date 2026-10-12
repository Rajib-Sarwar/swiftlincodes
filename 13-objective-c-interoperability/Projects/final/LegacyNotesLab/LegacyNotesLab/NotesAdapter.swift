import Foundation

func displayTitle(_ title: String) -> String {
    let clean = title.trimmingCharacters(in: .whitespacesAndNewlines)
    return clean.isEmpty ? "Untitled" : clean
}

struct NoteRow: Identifiable, Equatable {
    let id: String
    let title: String
    let body: String
    let badge: String
    init(_ note: SLNote) {
        id = note.identifier
        title = displayTitle(note.title)
        body = note.body ?? "No preview"
        switch note.kind {
        case .plain: badge = "Note"
        case .pinned: badge = "Pinned"
        @unknown default: badge = "Other"
        }
    }
}

enum NoteIssue: Error, Equatable {
    case invalidTitle, missingNote, other(domain: String, code: Int)
    var message: String {
        switch self {
        case .invalidTitle: return "Enter a title before saving."
        case .missingNote: return "This note is no longer available."
        case .other: return "Could not save this note."
        }
    }
}
func noteIssue(_ error: NSError) -> NoteIssue {
    guard error.domain == SLNoteErrorDomain else { return .other(domain: error.domain, code: error.code) }
    switch error.code {
    case 1: return .invalidTitle
    case 2: return .missingNote
    default: return .other(domain: error.domain, code: error.code)
    }
}

// The app owns this adapter on the main actor. Tests access it serially.
// Neither NSObject nor a bridging header makes a service thread-safe.
final class NotesAdapter {
    private let store: SLNoteStore
    init(store: SLNoteStore = SLNoteStore()) { self.store = store }
    var count: Int { Int(store.__noteCount()) }
    func rows() -> [NoteRow] { store.notes().map(NoteRow.init) }
    func rename(id: String, title: String) throws {
        do { try store.rename(id: id, title: title) }
        catch { throw noteIssue(error as NSError) }
    }
}

// Only this narrow surface is exposed to Objective-C; NoteRow stays Swift-only.
@objc(SLNoteFormatter)
final class NoteFormatter: NSObject {
    @objc(titleForNote:)
    static func title(for note: SLNote) -> String { displayTitle(note.title) }
}
