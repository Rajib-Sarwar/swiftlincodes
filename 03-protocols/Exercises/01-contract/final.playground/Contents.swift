// Complete the payment contract
// Reference solution: attempt the starter first.

protocol PaymentMethod {
    var name: String { get }
    var isEnabled: Bool { get set }
    func pay(amount: Double)
}
struct CreditCard: PaymentMethod {
    let name = "Credit Card"
    var isEnabled = true
    func pay(amount: Double) { print("Credit Card: paid \(amount)") }
}
struct GiftCard: PaymentMethod {
    let name = "Gift Card"
    var isEnabled = true
    func pay(amount: Double) { print("Gift Card: paid \(amount)") }
}
func checkout(using method: any PaymentMethod, amount: Double) {
    guard method.isEnabled else {
        print("\(method.name): disabled")
        return
    }
    method.pay(amount: amount)
}
checkout(using: CreditCard(), amount: 25)
var gift = GiftCard()
checkout(using: gift, amount: 10)
gift.isEnabled = false
checkout(using: gift, amount: 10)
