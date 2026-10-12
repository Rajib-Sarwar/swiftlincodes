final class LegacyNote {
    let id: String
    var title: String
    init(id: String, title: String) { self.id = id; self.title = title }
}
struct Row { let id: String; let title: String }
func snapshot(_ notes: [LegacyNote]) -> [Row] {
    // TODO: Copy the displayed values into Row; preserve source order and IDs.
    return []
}
let note = LegacyNote(id: "n1", title: "Before")
let originals = [note]
let rows = snapshot(originals)
note.title = "After"
print(rows.map { $0.title })
print(originals.map { $0.title })
print(rows.map { $0.id })
