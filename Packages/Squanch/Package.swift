// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Squanch",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(
            name: "Squanch",
            targets: ["Squanch"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Squanch",
            dependencies: []),
        .testTarget(
            name: "SquanchTests",
            dependencies: ["Squanch"]
        )
    ]
)
