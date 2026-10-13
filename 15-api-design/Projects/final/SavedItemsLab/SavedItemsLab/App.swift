import SwiftUI
import SavedItemsKit

@main
struct SavedItemsLabApp: App {
    var body: some Scene { WindowGroup { SavedItemsScreen() } }
}
struct SavedItemsScreen: View {
    // A fixed positive capacity is valid by construction in this teaching fixture.
    @State private var saved = try! SavedItems(capacity: 3)
    @State private var message = "Save up to three items. Try saving the same item twice."
    private let catalog = ["Offline maps", "Swift APIs", "Image caching", "App architecture"]
    var body: some View {
        NavigationStack {
            List {
                Section("Catalog") {
                    ForEach(catalog, id: \.self) { title in
                        Button { save(title) } label: {
                            HStack {
                                Text(title)
                                Spacer()
                                Image(systemName: saved.contains(SavedItemID(title)!) ? "bookmark.fill" : "bookmark")
                            }
                        }
                    }
                }
                Section("Saved \(saved.count) / \(saved.capacity)") {
                    if saved.ids.isEmpty { Text("Nothing saved yet").foregroundStyle(.secondary) }
                    ForEach(saved.ids, id: \.self) { id in
                        HStack {
                            Text(id.rawValue)
                            Spacer()
                            Button("Remove") { saved.remove(id); message = "Removed \(id.rawValue)." }
                                .buttonStyle(.borderless)
                        }
                    }
                }
                Section("Result") { Text(message).accessibilityIdentifier("operation-result") }
                Section { Text("In-memory demo. Relaunching starts a new collection. The screen imports SavedItemsKit as a separate module.").font(.footnote).foregroundStyle(.secondary) }
            }
            .navigationTitle("Saved Items Lab")
        }
    }
    private func save(_ title: String) {
        guard let id = SavedItemID(title) else { message = "Enter a nonempty ID."; return }
        do {
            switch try saved.insert(id) {
            case .inserted: message = "Saved \(title)."
            case .alreadySaved: message = "Already saved. Its position stays the same."
            }
        } catch SavedItems.Failure.capacityReached {
            message = "Your list is full. Remove an item before saving a new one."
        } catch { message = "Could not save: \(error)" }
    }
}
