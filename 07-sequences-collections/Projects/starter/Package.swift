// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "OfflineLibrary", platforms: [.macOS(.v13)], products: [.library(name: "LibraryCore", targets: ["LibraryCore"])], targets: [
    .target(name: "LibraryCore", path: "OfflineLibrary/OfflineLibrary", exclude: ["App.swift"]),
    .testTarget(name: "LibraryCoreTests", dependencies: ["LibraryCore"], path: "Tests")
])
