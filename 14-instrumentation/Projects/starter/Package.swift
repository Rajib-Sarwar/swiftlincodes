// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "CatalogPerformanceLab", platforms: [.macOS(.v13)], products: [.library(name: "PerformanceCore", targets: ["PerformanceCore"])], targets: [
    .target(name: "PerformanceCore", path: "CatalogPerformanceLab/CatalogPerformanceLab", exclude: ["App.swift"]),
    .testTarget(name: "PerformanceCoreTests", dependencies: ["PerformanceCore"], path: "Tests")
])
