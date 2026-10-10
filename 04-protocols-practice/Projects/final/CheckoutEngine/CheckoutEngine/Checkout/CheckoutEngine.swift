@MainActor
final class CheckoutEngine {
    private let processor: any PaymentProcessing

    weak var delegate: CheckoutEngineDelegate?

    init(processor: any PaymentProcessing) {
        self.processor = processor
    }

    func checkout(amount: Double) async {
        delegate?.checkoutDidStart(self)

        do {
            try await processor.pay(amount: amount)

            delegate?.checkoutEngine(
                self,
                didFinishWith: .success
            )
        } catch {
            delegate?.checkoutEngine(
                self,
                didFinishWith: .failure(error)
            )
        }
    }
}
