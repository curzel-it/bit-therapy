// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Physics",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "Physics",
            targets: ["Physics"])
    ],
    dependencies: [
        .package(path: "../Squanch"),
        .package(path: "../Schwifty")
    ],
    targets: [
        .target(
            name: "Physics",
            dependencies: [
                .product(name: "Squanch", package: "Squanch"),
                .product(name: "Schwifty", package: "Schwifty")
            ]),
        .testTarget(
            name: "PhysicsTests",
            dependencies: ["Physics"]
        )
    ]
)
