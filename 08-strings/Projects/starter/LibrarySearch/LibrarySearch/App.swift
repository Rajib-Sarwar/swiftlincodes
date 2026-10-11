import SwiftUI

@main
struct LibrarySearchApp: App {
    var body: some Scene { WindowGroup { SearchLibraryView() } }
}
struct SearchLibraryView: View {
    @State private var videos = sampleVideos + [
        Video(id: 6, title: "Café 2", isDownloaded: true, bytes: 12),
        Video(id: 7, title: "Cafe\u{301} 11", isDownloaded: true, bytes: 10),
        Video(id: 8, title: "👨‍👩‍👧‍👦 Family", isDownloaded: false, bytes: 8)
    ]
    @State private var query = ""
    @State private var selectedID = 1
    @State private var draft = "Swift types"
    @State private var localeID = "en_US"
    private var locale: Locale { Locale(identifier: localeID) }
    private var visible: [Video] {
        videos.filter { query.isEmpty || titleMatch($0.title, query: query, locale: locale) != nil }
            .sorted {
                let order = displayOrder($0.title, $1.title, locale: locale)
                return order == .orderedSame ? $0.id < $1.id : order == .orderedAscending
            }
    }
    var body: some View {
        NavigationStack {
            List {
                Section("Search policy") {
                    TextField("Search titles, e.g. cafe", text: $query)
                    Picker("Locale", selection: $localeID) {
                        Text("English").tag("en_US")
                        Text("Swedish").tag("sv_SE")
                        Text("Turkish").tag("tr_TR")
                    }
                    Text("Case- and accent-insensitive matching; numeric display ordering. Empty query shows all videos.").font(.caption)
                }
                Section("Library results") {
                    if visible.isEmpty { Text("No matching titles") }
                    ForEach(visible) { video in
                        Button {
                            selectedID = video.id; draft = video.title
                        } label: {
                            VStack(alignment: .leading, spacing: 5) {
                                highlighted(video.title)
                                Text("Preview: " + titlePreview(video.title, limit: 10)).font(.caption).foregroundStyle(.secondary)
                            }
                        }.buttonStyle(.plain)
                    }
                }
                Section("Rename selected video") {
                    TextField("Title", text: $draft)
                    Text("\(draft.count)/30 Characters · \(draft.utf8.count)/60 UTF-8 bytes").font(.caption)
                    if let issue = validateTitle(draft) { Text(issue.rawValue).foregroundStyle(.red) }
                    Button("Save title") {
                        guard validateTitle(draft) == nil,
                              let index = videos.firstIndex(where: { $0.id == selectedID }) else { return }
                        videos[index].title = draft
                    }.disabled(validateTitle(draft) != nil)
                    Button("Cancel edits") {
                        draft = videos.first(where: { $0.id == selectedID })?.title ?? ""
                    }
                    Text("Nonblank text, at most 30 Characters and 60 UTF-8 bytes. Whitespace is preserved when saving. These are teaching limits, not a universal title policy.").font(.caption)
                }
                Section("Inspect the draft") {
                    Text("\(draft.unicodeScalars.count) Unicode scalars · \(draft.utf16.count) UTF-16 units")
                    Text("Exact palindrome: \(isExactPalindrome(draft) ? "yes" : "no")")
                    Text("First unique Character: " + (firstUniqueCharacter(draft).map(String.init) ?? "none"))
                }
            }.navigationTitle("Search & Rename")
        }
    }
    private func highlighted(_ title: String) -> Text {
        guard let range = titleMatch(title, query: query, locale: locale) else { return Text(title) }
        return Text(String(title[..<range.lowerBound]))
            + Text(String(title[range])).bold().foregroundColor(.orange)
            + Text(String(title[range.upperBound...]))
    }
}
