final class LegacyNote {
    let id: String
    var title: String
    init(id: String, title: String) { self.id = id; self.title = title }
}
struct Row { let id: String; let title: String }
func snapshot(_ notes: [LegacyNote]) -> [Row] {
    notes.map { Row(id: $0.id, title: $0.title) }
}
let note = LegacyNote(id: "n1", title: "Before")
let originals = [note]
let rows = snapshot(originals)
note.title = "After"
print(rows.map { $0.title })
print(originals.map { $0.title })
print(rows.map { $0.id })
