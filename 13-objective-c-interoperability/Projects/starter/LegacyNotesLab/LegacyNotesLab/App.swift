import SwiftUI
import Combine

@MainActor
final class NotesModel: ObservableObject {
    @Published private(set) var rows: [NoteRow] = []
    @Published private(set) var message = "Local fixture. Changes reset when you relaunch."
    private let adapter = NotesAdapter()
    init() { rows = adapter.rows() }
    func rename(_ title: String, id: String = "welcome") {
        do {
            try adapter.rename(id: id, title: title)
            rows = adapter.rows()
            message = "Saved and reloaded a Swift snapshot."
        } catch let issue as NoteIssue { message = issue.message }
          catch { message = "Unexpected failure." }
    }
    var legacyPreview: String {
        let note = SLNote(identifier: "preview", title: "  Swift formatter  ", body: nil, kind: .plain)
        return SLLegacyPreview(note)
    }
}

@main
struct LegacyNotesApp: App {
    @StateObject private var model = NotesModel()
    @State private var title = "A better title"
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                List {
                    Section("Rename the welcome note") {
                        TextField("Title", text: $title)
                        Button("Save title") { model.rename(title) }
                        Button("Try blank title") { model.rename("   ") }
                        Button("Try missing note") { model.rename("New", id: "missing") }
                        Text(model.message).font(.footnote)
                    }
                    Section("Swift value snapshots") {
                        ForEach(model.rows) { row in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(row.title).font(.headline)
                                Text(row.body).font(.subheadline)
                                Text(row.badge).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                    Section("Objective-C calls Swift") { Text(model.legacyPreview) }
                }.navigationTitle("Legacy Notes Lab")
            }
        }
    }
}
