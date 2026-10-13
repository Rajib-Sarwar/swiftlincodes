// swift-tools-version: 6.0
import PackageDescription
let package = Package(
    name: "SavedItemsKit",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [.library(name: "SavedItemsKit", targets: ["SavedItemsKit"])],
    targets: [.target(name: "SavedItemsKit"), .testTarget(name: "SavedItemsKitTests", dependencies: ["SavedItemsKit"]) ]
)
