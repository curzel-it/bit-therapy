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
        .package(path: "../DesignSystem"),
        .package(path: "../Squanch"),
        .package(path: "../Schwifty")
    ],
    targets: [
        .target(
            name: "Physics",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "Squanch", package: "Squanch"),
                .product(name: "Schwifty", package: "Schwifty")
            ]),
        .testTarget(
            name: "PhysicsTests",
            dependencies: [
                "Physics",
                .product(name: "Squanch", package: "Squanch")
            ]
        )
    ]
)
