import Combine
let query = PassthroughSubject<String, Never>()
let online = CurrentValueSubject<Bool, Never>(true)
// Retain the subscription until explicit cancellation.
let token = query.combineLatest(online)
    .map { text, connected in text.count >= 2 && connected }
    .sink { print($0) }
query.send("sw")
online.send(false)
query.send("swift")
online.send(true)
token.cancel()
query.send("ignored")
// Expected: true, false, false, true. No output after cancellation.
