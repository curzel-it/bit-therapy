// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Biosphere",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(
            name: "Biosphere",
            targets: ["Biosphere"])
    ],
    dependencies: [
        .package(path: "../Squanch"),
        .package(path: "../Schwifty")
    ],
    targets: [
        .target(
            name: "Biosphere",
            dependencies: [
                .product(name: "Squanch", package: "Squanch"),
                .product(name: "Schwifty", package: "Schwifty")
            ]),
        .testTarget(
            name: "BiosphereTests",
            dependencies: [
                "Biosphere",
                .product(name: "Squanch", package: "Squanch")
            ]
        )
    ]
)
