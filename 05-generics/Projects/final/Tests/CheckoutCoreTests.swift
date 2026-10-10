import XCTest
@testable import CheckoutCore

private enum StubError: Error { case declined }
private actor MockPaymentProcessor: PaymentProcessing {
    let fails: Bool
    private(set) var amounts: [Double] = []
    init(fails: Bool = false) { self.fails = fails }
    func pay(amount: Double) async throws {
        amounts.append(amount)
        if fails { throw StubError.declined }
    }
}
@MainActor private final class DelegateSpy: CheckoutEngineDelegate {
    var events: [String] = []
    func checkoutDidStart(_ engine: CheckoutEngine) { events.append("start") }
    func checkoutEngine(_ engine: CheckoutEngine, didFinishWith result: CheckoutResult) {
        switch result {
        case .success: events.append("success")
        case .failure: events.append("failure")
        }
    }
}
final class CheckoutCoreTests: XCTestCase {
    @MainActor func testSuccessForwardsAmountAndUpdatesViewModel() async {
        let processor = MockPaymentProcessor()
        let engine = CheckoutEngine(processor: PaymentService(processor: processor))
        let model = CheckoutViewModel(engine: engine)
        await model.checkout(amount: 42)
        let amounts = await processor.amounts
        XCTAssertEqual(amounts, [42])
        XCTAssertEqual(model.status, "Payment completed")
        XCTAssertFalse(model.isProcessing)
    }
    @MainActor func testFailureUpdatesViewModel() async {
        let engine = CheckoutEngine(processor: PaymentService(processor: MockPaymentProcessor(fails: true)))
        let model = CheckoutViewModel(engine: engine)
        await model.checkout(amount: 42)
        XCTAssertEqual(model.status, "Payment failed")
        XCTAssertFalse(model.isProcessing)
    }
    @MainActor func testDelegateReceivesEventsInOrder() async {
        for fails in [false, true] {
            let engine = CheckoutEngine(processor: MockPaymentProcessor(fails: fails))
            let spy = DelegateSpy()
            engine.delegate = spy
            await engine.checkout(amount: 42)
            XCTAssertEqual(spy.events, ["start", fails ? "failure" : "success"])
        }
    }
    @MainActor func testDelegateIsWeak() {
        let engine = CheckoutEngine(processor: MockPaymentProcessor())
        var spy: DelegateSpy? = DelegateSpy()
        engine.delegate = spy
        spy = nil
        XCTAssertNil(engine.delegate)
    }
    func testProcessorsRejectInvalidAmount() async {
        let processors: [any PaymentProcessing] = [CreditCardProcessor(), GiftCardProcessor()]
        for processor in processors {
            for amount in [0.0, -1.0] {
                do { try await processor.pay(amount: amount); XCTFail("Expected rejection") }
                catch { XCTAssertTrue(error is PaymentError) }
            }
        }
    }
}
