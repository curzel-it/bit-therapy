// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Tracking",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "Tracking",
            targets: ["Tracking"]
        )
    ],
    dependencies: [
        .package(path: "../Lang"),
        .package(path: "../Pets"),
        .package(path: "../Squanch")
    ],
    targets: [
        .target(
            name: "Tracking",
            dependencies: [
                .product(name: "Lang", package: "Lang"),
                .product(name: "Pets", package: "Pets"),
                .product(name: "Squanch", package: "Squanch")
            ]
        )
    ]
)
