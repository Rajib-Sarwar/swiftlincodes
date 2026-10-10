// Spend from a copy of a gift card
// Reference solution: attempt the starter first.

protocol PaymentMethod {
    var name: String { get }
    mutating func pay(amount: Double)
}
struct GiftCard: PaymentMethod {
    let name = "Gift Card"
    var balance: Double
    mutating func pay(amount: Double) { balance -= amount }
}
let original = GiftCard(balance: 100)
var copy = original
copy.pay(amount: 25)
print("Original: \(original.balance)")
print("Copy: \(copy.balance)")
