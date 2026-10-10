//
//  CheckoutView.swift
//  CheckoutEngine
//
//  Copyright © 2026 Swiftlin. All rights reserved.
//  See LICENSE for license terms.
//

import SwiftUI

struct CheckoutView: View {

    @StateObject
    private var viewModel = CheckoutViewModel()

    var body: some View {
        VStack(spacing: 24) {

            Image(systemName: "creditcard.fill")
                .font(.system(size: 60))

            Text("Checkout")
                .font(.largeTitle)
                .bold()

            Text("$100.00")
                .font(.title)

            Button {
                Task {
                    await viewModel.checkout(
                        amount: 100
                    )
                }
            } label: {
                Text("Pay with Credit Card")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Text(viewModel.status)
                .foregroundStyle(.secondary)
        }
        .padding(30)
    }
}
