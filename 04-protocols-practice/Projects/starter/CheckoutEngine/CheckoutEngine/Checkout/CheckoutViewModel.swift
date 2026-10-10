//
//  CheckoutViewModel.swift
//  CheckoutEngine
//
//  Created by Chowdhury Md Rajib Sarwar on 10/7/26.
//

import Foundation
import Combine

@MainActor
final class CheckoutViewModel: ObservableObject {

    @Published private(set) var status = "Ready"

    private let processor = CreditCardProcessor()

    func checkout(amount: Double) async {
        status = "Processing..."

        do {
            try await processor.pay(
                amount: amount
            )

            status = "Payment completed"
        } catch {
            status = "Payment failed"
        }
    }
}
