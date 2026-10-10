// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "CheckoutReference",
    platforms: [.macOS(.v13)],
    products: [.library(name: "CheckoutCore", targets: ["CheckoutCore"])],
    targets: [
        .target(name: "CheckoutCore", path: "CheckoutEngine/CheckoutEngine",
                exclude: ["App", "Assets.xcassets", "Checkout/CheckoutView.swift", "CheckoutEngineTests"]),
        .testTarget(name: "CheckoutCoreTests", dependencies: ["CheckoutCore"], path: "Tests")
    ]
)
