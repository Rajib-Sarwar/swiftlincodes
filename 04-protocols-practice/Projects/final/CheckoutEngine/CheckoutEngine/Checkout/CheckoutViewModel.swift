import Combine

@MainActor
final class CheckoutViewModel: ObservableObject {
    private let engine: CheckoutEngine
    @Published private(set) var status = "Ready"
    @Published private(set) var isProcessing = false

    init(engine: CheckoutEngine) {
        self.engine = engine
        self.engine.delegate = self
    }

    func checkout(amount: Double) async {
        guard !isProcessing else { return }
        await engine.checkout(amount: amount)
    }
}

extension CheckoutViewModel: CheckoutEngineDelegate {
    func checkoutDidStart(_ engine: CheckoutEngine) {
        isProcessing = true
        status = "Processing..."
    }
    func checkoutEngine(_ engine: CheckoutEngine, didFinishWith result: CheckoutResult) {
        isProcessing = false
        switch result {
        case .success: status = "Payment completed"
        case .failure: status = "Payment failed"
        }
    }
}
