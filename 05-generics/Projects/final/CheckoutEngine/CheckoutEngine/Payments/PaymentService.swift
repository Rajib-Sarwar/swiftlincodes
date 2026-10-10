struct PaymentService<Processor: PaymentProcessing>: Sendable {
    let processor: Processor
    func checkout(amount: Double) async throws {
        try await processor.pay(amount: amount)
    }
}
extension PaymentService: PaymentProcessing {
    func pay(amount: Double) async throws {
        try await checkout(amount: amount)
    }
}
