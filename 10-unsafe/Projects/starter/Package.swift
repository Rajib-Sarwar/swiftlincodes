// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "PacketLab", platforms: [.macOS(.v13)], products: [.library(name: "PacketCodec", targets: ["PacketCodec"])], targets: [
.target(name: "PacketCodec", path: "PacketLab/PacketLab", exclude: ["App.swift"]),
.testTarget(name: "PacketCodecTests", dependencies: ["PacketCodec"], path: "Tests")
])
