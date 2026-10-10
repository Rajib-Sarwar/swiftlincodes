// Compare receipts from different sources
// Declare two source type parameters, A and B, constrained to ReceiptSource.
// Require their Receipt types to be the same and that type to conform to Equatable.
// Return equality of the produced receipts. Print a matching and a nonmatching comparison.

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

// TODO: Write sameReceipt(from:and:) using two generic source types.
// Require equal Receipt types and Equatable receipts.

let live = CardReceiptSource()
let same = CachedCardReceiptSource(cached: CardReceipt(reference: "card-101"))
let different = CachedCardReceiptSource(cached: CardReceipt(reference: "card-999"))
// TODO: Compare live with same, then live with different. Print both results.

