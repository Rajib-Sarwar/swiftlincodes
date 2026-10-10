struct GiftCardProcessor: PaymentProcessing {
    func pay(amount: Double) async throws {
        guard amount > 0 else { throw PaymentError.invalidAmount }
        try await Task.sleep(for: .milliseconds(700))
        print("Gift card payment completed: $\(amount)")
    }
}
