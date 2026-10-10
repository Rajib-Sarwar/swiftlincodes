// Compare receipts from different sources
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

func sameReceipt<A: ReceiptSource, B: ReceiptSource>(from first: A, and second: B) -> Bool
where A.Receipt == B.Receipt, A.Receipt: Equatable {
    first.receipt() == second.receipt()
}
let live = CardReceiptSource()
let same = CachedCardReceiptSource(cached: CardReceipt(reference: "card-101"))
let different = CachedCardReceiptSource(cached: CardReceipt(reference: "card-999"))
print(sameReceipt(from: live, and: same))
print(sameReceipt(from: live, and: different))
