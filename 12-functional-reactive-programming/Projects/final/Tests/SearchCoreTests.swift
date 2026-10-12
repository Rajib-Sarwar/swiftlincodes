import Combine
import Foundation
import Testing
@testable import SearchCore

// No real time, network, run-loop polling, or sleeps in these tests.
final class Harness {
    let input = PassthroughSubject<String, Never>()
    var gates: [PassthroughSubject<Void, Never>] = []
    var requests: [(String, PassthroughSubject<[String], Error>)] = []
    var cancelled: [String] = []
    var states: [SearchState] = []
    var token: AnyCancellable?
    init() {
        token = searchStates(input: input.eraseToAnyPublisher(), waitForQuiet: { [unowned self] in
            let gate = PassthroughSubject<Void, Never>(); gates.append(gate)
            return gate.eraseToAnyPublisher()
        }, search: { [unowned self] query in
            let result = PassthroughSubject<[String], Error>(); requests.append((query,result))
            return result.handleEvents(receiveCancel: { [weak self] in self?.cancelled.append(query) }).eraseToAnyPublisher()
        }).sink { [weak self] in self?.states.append($0) }
    }
}
@Test func normalization() { #expect(normalizeQuery("  SWIFT\n") == "swift") }
@Test func shortQueryIsIdle() {
    let h = Harness(); h.input.send("s")
    #expect(h.states == [.idle]); #expect(h.gates.isEmpty); #expect(h.requests.isEmpty)
}
@Test func waitThenLoadThenResults() {
    let h = Harness(); h.input.send("swift")
    #expect(h.states == [.waiting("swift")]); #expect(h.requests.isEmpty)
    h.gates[0].send(()); #expect(h.states.last == .loading("swift"))
    h.requests[0].1.send(["Swift Basics"])
    #expect(h.states.last == .results("swift", ["Swift Basics"]))
}
@Test func cancelledQuietPeriodNeverRequests() {
    let h = Harness(); h.input.send("sw"); h.input.send("swift")
    h.gates[0].send(()); #expect(h.requests.isEmpty)
    h.gates[1].send(()); #expect(h.requests.map(\.0) == ["swift"])
}
@Test func oldResponseIgnoredDuringNewQuietPeriod() {
    let h = Harness(); h.input.send("sw"); h.gates[0].send(())
    h.input.send("swift"); #expect(h.cancelled == ["sw"])
    h.requests[0].1.send(["Old"])
    #expect(h.states.last == .waiting("swift"))
    h.gates[1].send(()); h.requests[1].1.send(["New"])
    #expect(h.states.last == .results("swift", ["New"]))
}
@Test func blankCancelsAndClears() {
    let h = Harness(); h.input.send("swift"); h.gates[0].send(())
    h.input.send("  "); h.requests[0].1.send(["Late"])
    #expect(h.states.last == .idle); #expect(h.cancelled == ["swift"])
}
@Test func normalizedDuplicatesSuppressed() {
    let h = Harness(); h.input.send(" SWIFT "); h.input.send("swift")
    #expect(h.gates.count == 1)
}
@Test func failureDoesNotKillFutureInput() {
    let h = Harness(); h.input.send("error"); h.gates[0].send(())
    h.requests[0].1.send(completion: .failure(URLError(.notConnectedToInternet)))
    #expect(h.states.last == .failed("error", "Search unavailable. Change the query to try again."))
    h.input.send("swift"); h.gates[1].send(()); h.requests[1].1.send(["Recovered"])
    #expect(h.states.last == .results("swift", ["Recovered"]))
}
@Test func emptySuccessIsNotFailure() {
    let h = Harness(); h.input.send("none"); h.gates[0].send(()); h.requests[0].1.send([])
    #expect(h.states.last == .results("none", []))
}
@Test func cancellationReachesActiveService() {
    let h = Harness(); h.input.send("swift"); h.gates[0].send(())
    h.token?.cancel(); #expect(h.cancelled == ["swift"])
    let count=h.states.count; h.requests[0].1.send(["Late"]); #expect(h.states.count == count)
}
@Test func oneGateStartsOneRequest() {
    let h=Harness(); h.input.send("swift"); h.gates[0].send(()); h.gates[0].send(())
    #expect(h.requests.count == 1)
}
@Test func combineLatestNeedsBothAndThenUpdates() {
    let a=PassthroughSubject<String,Never>(); let b=PassthroughSubject<Bool,Never>()
    var values:[String]=[]
    let token=a.combineLatest(b).sink { values.append("\($0):\($1)") }
    a.send("sw"); #expect(values.isEmpty)
    b.send(true); a.send("swift"); b.send(false)
    #expect(values == ["sw:true","swift:true","swift:false"])
    withExtendedLifetime(token) {}
}
