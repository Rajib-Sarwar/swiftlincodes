// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "LibrarySync", platforms: [.macOS(.v13)], products: [.library(name: "LibraryCodec", targets: ["LibraryCodec"])], targets: [
.target(name: "LibraryCodec", path: "LibrarySync/LibrarySync", exclude: ["App.swift"]),
.testTarget(name: "LibraryCodecTests", dependencies: ["LibraryCodec"], path: "Tests")
])
