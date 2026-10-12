import SwiftUI
import Combine

@MainActor
final class SearchModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var state: SearchState = .idle
    private var subscription: AnyCancellable?
    init() {
        subscription = searchStates(
            input: $query.eraseToAnyPublisher(),
            waitForQuiet: {
                Just(())
                    .delay(for: .milliseconds(300), scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            },
            search: demoSearch
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] state in
            // receive(on:) establishes this runtime scheduling boundary.
            // Combine itself does not statically express actor isolation.
            MainActor.assumeIsolated { self?.state = state }
        }
    }
}
@main
struct LiveSearchLabApp: App {
    var body: some Scene { WindowGroup { SearchScreen() } }
}
struct SearchScreen: View {
    @StateObject private var model = SearchModel()
    var body: some View {
        NavigationStack {
            List {
                Section("Search the local catalog") {
                    TextField("At least two characters", text: $model.query)
                        .textInputAutocapitalization(.never).autocorrectionDisabled()
                    HStack {
                        Button("Swift") { model.query = "swift" }
                        Button("Combine") { model.query = "combine" }
                        Button("Error") { model.query = "error" }
                    }.buttonStyle(.bordered)
                }
                Section("Current state") {
                    switch model.state {
                    case .idle: Text("Type at least two characters.")
                    case .waiting(let query): Text("Waiting for typing to pause: \(query)")
                    case .loading(let query): ProgressView("Searching: \(query)")
                    case .results(let query, let rows):
                        Text("\(rows.count) results for \(query)").font(.headline)
                        if rows.isEmpty { Text("No matches. Try another query.") }
                        ForEach(rows, id: \.self) { Text($0) }
                    case .failed(let query, let message):
                        Label("Could not search: \(query)", systemImage: "exclamationmark.triangle")
                        Text(message)
                    }
                }
                Section("Try the timing") {
                    Text("Type sw, wait until searching starts, then type swift. The old request is cancelled as soon as the new normalized query arrives, including its quiet period.")
                    Text("Error simulates a failed request. Then choose Swift to verify recovery. This app uses local fixtures, not the internet.")
                }.font(.footnote)
            }.navigationTitle("Live Search Lab")
        }
    }
}
