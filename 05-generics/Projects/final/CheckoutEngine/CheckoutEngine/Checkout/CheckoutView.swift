import SwiftUI

struct CheckoutView: View {
    @StateObject private var viewModel = CheckoutViewModel(
        engine: CheckoutEngine(processor: PaymentService(processor: CreditCardProcessor()))
    )

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "creditcard.fill").font(.system(size: 60))
            Text("Checkout").font(.largeTitle).bold()
            Text("$100.00").font(.title)
            Button {
                Task { await viewModel.checkout(amount: 100) }
            } label: {
                Text(viewModel.isProcessing ? "Processing..." : "Pay with Credit Card")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isProcessing)
            Text(viewModel.status).foregroundStyle(.secondary)
        }
        .padding(30)
    }
}
