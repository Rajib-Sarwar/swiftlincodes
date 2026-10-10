// Diagnose the dispatch surprise
// Reference solution: attempt the starter first.

protocol PaymentMethod {
    func process()
    func debugInfo()
}
extension PaymentMethod {
    func process() { print("Processing generic payment") }
    func debugInfo() { print("Generic payment") }
}
struct GiftCard: PaymentMethod {
    func process() { print("Processing gift card") }
    func debugInfo() { print("Gift card") }
}
let card = GiftCard()
let payment: any PaymentMethod = card
card.process()
payment.process()
card.debugInfo()
payment.debugInfo()
