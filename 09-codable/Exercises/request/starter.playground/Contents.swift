import Foundation
struct RenameRequest: Encodable {
    let id: String
    let title: String
    let isEditorExpanded: Bool // Local UI state: never send this.
    enum CodingKeys: String, CodingKey { case id, changes }
    enum ChangeKeys: String, CodingKey { case title }
    func encode(to encoder: any Encoder) throws {
        var root = encoder.container(keyedBy: CodingKeys.self)
        // TODO: Encode id and nested changes.title. Omit UI state.
    }
}
let encoder = JSONEncoder()
encoder.outputFormatting = [.sortedKeys]
let request = RenameRequest(id: "v1", title: "Café", isEditorExpanded: true)
print(String(decoding: try encoder.encode(request), as: UTF8.self))
