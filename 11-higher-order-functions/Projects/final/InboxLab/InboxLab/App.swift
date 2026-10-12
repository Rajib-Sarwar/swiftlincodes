import SwiftUI

@main
struct InboxLabApp: App {
    var body: some Scene { WindowGroup { InboxView() } }
}
struct InboxView: View {
    @State private var unreadOnly = true
    @State private var minimumPriority = 0
    @State private var category = "all"
    private let report = importNotices(sampleRows)
    var body: some View {
        let options = InboxOptions(unreadOnly: unreadOnly, minimumPriority: minimumPriority,
            category: category == "all" ? nil : category)
        let visible = visibleNotices(report.accepted, options: options)
        let counts = categoryCounts(visible)
        NavigationStack {
            List {
                Section("Choose your inbox") {
                    Toggle("Unread only", isOn: $unreadOnly)
                    Stepper("Minimum priority: \(minimumPriority)", value: $minimumPriority, in: 0...3)
                    Picker("Category", selection: $category) {
                        Text("All").tag("all")
                        Text("Work").tag("work")
                        Text("Social").tag("social")
                    }
                }
                Section("Import report") {
                    Text("\(report.accepted.count) accepted · \(report.rejectedIDs.count) rejected")
                    if !report.rejectedIDs.isEmpty {
                        Text("Invalid priority at IDs: " + report.rejectedIDs.map(String.init).joined(separator: ", "))
                            .foregroundStyle(.secondary)
                    }
                }
                Section("Visible by category") {
                    if counts.isEmpty { Text("No matching notifications") }
                    ForEach(counts.keys.sorted(), id: \.self) { key in
                        LabeledContent(key.capitalized, value: String(counts[key, default: 0]))
                    }
                }
                Section("\(visible.count) notifications") {
                    ForEach(visible) { notice in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(rowTitles([notice])[0]).font(.headline)
                            Text("#\(notice.id) · \(notice.category) · \(notice.isRead ? "Read" : "Unread")")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
                Section {
                    Text("Priority highest first, then ID lowest first. Counts describe only the visible inbox.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }.navigationTitle("Inbox Lab")
        }
    }
}
