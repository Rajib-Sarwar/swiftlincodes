struct CreditCardProcessor: PaymentProcessing {
    func pay(amount: Double) async throws {
        guard amount > 0 else { throw PaymentError.invalidAmount }
        try await Task.sleep(for: .milliseconds(700))
        print("Credit card payment completed: $\(amount)")
    }
}
