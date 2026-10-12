// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "LiveSearchLab", platforms: [.macOS(.v13)], products: [.library(name: "SearchCore", targets: ["SearchCore"])], targets: [
.target(name: "SearchCore", path: "LiveSearchLab/LiveSearchLab", exclude: ["App.swift"]),
.testTarget(name: "SearchCoreTests", dependencies: ["SearchCore"], path: "Tests")
])
