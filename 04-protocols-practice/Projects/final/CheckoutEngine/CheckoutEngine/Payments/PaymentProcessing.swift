protocol PaymentProcessing: Sendable {
    func pay(amount: Double) async throws
}
