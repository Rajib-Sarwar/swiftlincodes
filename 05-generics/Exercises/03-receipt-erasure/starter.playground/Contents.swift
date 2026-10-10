// Mix source types without losing receipt information
// Create sources with CardReceiptSource and a cached source returning cached-202.
// Give the array an explicit element type that hides the source type but fixes its Receipt to CardReceipt.
// Loop over the sources and print reference directly, without as?, as!, or Any.

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

// TODO: Declare sources containing one CardReceiptSource and one
// CachedCardReceiptSource with reference "cached-202".
// Hide source identity, but keep Receipt exactly CardReceipt.
// Print each returned receipt's reference without a cast.

