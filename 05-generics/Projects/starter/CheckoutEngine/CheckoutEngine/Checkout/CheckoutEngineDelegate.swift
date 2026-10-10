@MainActor
protocol CheckoutEngineDelegate: AnyObject {
    func checkoutDidStart(_ engine: CheckoutEngine)

    func checkoutEngine(
        _ engine: CheckoutEngine,
        didFinishWith result: CheckoutResult
    )
}
