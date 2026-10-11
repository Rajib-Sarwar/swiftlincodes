// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "LibrarySearch", platforms: [.macOS(.v13)], products: [.library(name: "LibraryText", targets: ["LibraryText"])], targets: [
    .target(name: "LibraryText", path: "LibrarySearch/LibrarySearch", exclude: ["App.swift"]),
    .testTarget(name: "LibraryTextTests", dependencies: ["LibraryText"], path: "Tests")
])
