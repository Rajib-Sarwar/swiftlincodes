// Complete the payment contract
// Make CreditCard and GiftCard conform to PaymentMethod. Use a readable name and a writable isEnabled property.
// Implement GiftCard.pay(amount:) to print “Gift Card: paid” followed by the amount, matching the credit-card format.
// Pay 25 with a credit card, pay 10 with a gift card, then disable the gift card and attempt 10 again.

protocol PaymentMethod {
    var name: String { get }
    var isEnabled: Bool { get set }
    func pay(amount: Double)
}

// TODO: Make both types conform to PaymentMethod.
struct CreditCard {
    let name = "Credit Card"
    var isEnabled = true
    func pay(amount: Double) {
        print("Credit Card: paid \(amount)")
    }
}
struct GiftCard {
    let name = "Gift Card"
    // TODO: Supply the writable property and payment method.
}

func checkout(using method: any PaymentMethod, amount: Double) {
    guard method.isEnabled else {
        print("\(method.name): disabled")
        return
    }
    method.pay(amount: amount)
}

// TODO: Check out with both types, then disable a gift card and try again.

