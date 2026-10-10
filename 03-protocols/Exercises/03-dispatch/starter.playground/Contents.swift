// Diagnose the dispatch surprise
// Before running, write a prediction for all four printed lines in the reflection field below.
// Run the unchanged starter. Compare process() and debugInfo() through the concrete and protocol-typed values.
// Change only the protocol declaration so both debugInfo() calls use GiftCard’s implementation. Keep the extension defaults and both call sites.

protocol PaymentMethod {
    func process()
    // TODO: After predicting and running, fix the contract here.
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

