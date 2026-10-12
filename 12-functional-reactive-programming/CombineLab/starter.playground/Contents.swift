import Combine
let query = PassthroughSubject<String, Never>()
let online = CurrentValueSubject<Bool, Never>(true)
// TODO: Combine current inputs, map eligibility, and retain the subscription.
let token = query.map { _ in false }
    .sink { print($0) }
query.send("sw")
online.send(false)
query.send("swift")
online.send(true)
token.cancel()
query.send("ignored")
// Expected: true, false, false, true. No output after cancellation.
