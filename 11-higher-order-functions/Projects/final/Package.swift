// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "InboxLab", platforms: [.macOS(.v13)], products: [.library(name: "InboxCore", targets: ["InboxCore"])], targets: [
    .target(name: "InboxCore", path: "InboxLab/InboxLab", exclude: ["App.swift"]),
    .testTarget(name: "InboxCoreTests", dependencies: ["InboxCore"], path: "Tests")
])
