// Mix source types without losing receipt information
// Reference solution: attempt the starter first.

struct CardReceipt: Equatable {
    let reference: String
}
protocol ReceiptSource<Receipt> {
    associatedtype Receipt
    func receipt() -> Receipt
}
struct CardReceiptSource: ReceiptSource {
    func receipt() -> CardReceipt { CardReceipt(reference: "card-101") }
}
struct CachedCardReceiptSource: ReceiptSource {
    let cached: CardReceipt
    func receipt() -> CardReceipt { cached }
}

let sources: [any ReceiptSource<CardReceipt>] = [
    CardReceiptSource(),
    CachedCardReceiptSource(cached: CardReceipt(reference: "cached-202"))
]
for source in sources {
    print(source.receipt().reference)
}
