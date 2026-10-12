import Foundation
import Combine

enum SearchState: Equatable {
    case idle
    case waiting(String)
    case loading(String)
    case results(String, [String])
    case failed(String, String)
}
func normalizeQuery(_ text: String) -> String {
    text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
}

// Callers serialize input, gate, and service events. Production uses the main queue.
// search must return a one-result publisher or a failure; it must not finish empty.
// waitForQuiet emits once when the quiet interval expires. Switching cancels old gates.
func searchStates(
    input: AnyPublisher<String, Never>,
    waitForQuiet: @escaping () -> AnyPublisher<Void, Never>,
    search: @escaping (String) -> AnyPublisher<[String], Error>
) -> AnyPublisher<SearchState, Never> {
    // TODO 1: Normalize input and suppress consecutive equivalent queries.
    input
        .map { query -> AnyPublisher<SearchState, Never> in
            // TODO 2: Treat queries shorter than two Characters as idle.
            guard !query.isEmpty else {
                return Just(SearchState.idle).eraseToAnyPublisher()
            }
            return waitForQuiet().prefix(1)
                .flatMap { _ -> AnyPublisher<SearchState, Never> in
                    Deferred { search(query) }
                        .map { SearchState.results(query, $0) }
                        // TODO 4: Keep the query and represent failure honestly.
                        .catch { _ in Just(SearchState.results(query, [])) }
                        .prepend(SearchState.loading(query))
                        .eraseToAnyPublisher()
                }
                .prepend(SearchState.waiting(query))
                .eraseToAnyPublisher()
        }
        // TODO 3: Replace flatMap with the latest-request policy.
        .flatMap { $0 }
        .eraseToAnyPublisher()
}

// This local fixture is not a network client. Deferred builds work per subscription.
func demoSearch(_ query: String) -> AnyPublisher<[String], Error> {
    Deferred {
        Just(query)
            .delay(for: .milliseconds(query == "sw" ? 900 : 200), scheduler: DispatchQueue.main)
            .tryMap { query in
                if query == "error" { throw URLError(.notConnectedToInternet) }
                return ["Swift Basics", "SwiftUI Layout", "Combine Streams", "Testing Swift"]
                    .filter { $0.lowercased().contains(query) }
            }
    }.eraseToAnyPublisher()
}
