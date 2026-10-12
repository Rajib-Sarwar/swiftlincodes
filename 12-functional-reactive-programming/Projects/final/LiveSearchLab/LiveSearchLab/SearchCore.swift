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
    input.map(normalizeQuery).removeDuplicates()
        .map { query -> AnyPublisher<SearchState, Never> in
            guard query.count >= 2 else {
                return Just(SearchState.idle).eraseToAnyPublisher()
            }
            return waitForQuiet().prefix(1)
                .flatMap { _ -> AnyPublisher<SearchState, Never> in
                    Deferred { search(query) }
                        .map { SearchState.results(query, $0) }
                        .catch { _ in Just(SearchState.failed(query, "Search unavailable. Change the query to try again.")) }
                        .prepend(SearchState.loading(query))
                        .eraseToAnyPublisher()
                }
                .prepend(SearchState.waiting(query))
                .eraseToAnyPublisher()
        }
        .switchToLatest()
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
