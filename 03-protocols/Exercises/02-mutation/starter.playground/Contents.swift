// Spend from a copy of a gift card
// Before editing, predict the original and copied balances after spending 25. Write your prediction in the reflection field below.
// Allow mutation in the protocol, then implement pay(amount:) by subtracting from balance.
// Run the supplied calls. Try a second payment of 10 on the copy and inspect both balances again.

protocol PaymentMethod {
    var name: String { get }
    // TODO: Allow a value-type implementation to change its state.
    func pay(amount: Double)
}
struct GiftCard: PaymentMethod {
    let name = "Gift Card"
    var balance: Double
    // TODO: Update the balance and mark the implementation appropriately.
    func pay(amount: Double) {
    }
}
let original = GiftCard(balance: 100)
var copy = original
copy.pay(amount: 25)
print("Original: \(original.balance)")
print("Copy: \(copy.balance)")

