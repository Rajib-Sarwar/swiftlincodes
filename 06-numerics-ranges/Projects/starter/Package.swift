// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "DownloadLab", platforms: [.macOS(.v13)], products: [.library(name: "DownloadCore", targets: ["DownloadCore"])], targets: [
    .target(name: "DownloadCore", path: "OfflineDownloadLab/OfflineDownloadLab", exclude: ["App.swift"]),
    .testTarget(name: "DownloadCoreTests", dependencies: ["DownloadCore"], path: "Tests")
])
