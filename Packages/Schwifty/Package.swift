// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Schwifty",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(
            name: "Schwifty",
            targets: ["Schwifty"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Schwifty",
            dependencies: []),
        .testTarget(
            name: "SchwiftyTests",
            dependencies: ["Schwifty"]
        )
    ]
)
