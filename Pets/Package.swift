// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Pets",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "Pets",
            targets: ["Pets"]
        )
    ],
    dependencies: [
        .package(path: "../AppState"),
        .package(path: "../Biosphere"),
        .package(path: "../DesignSystem"),
        .package(path: "../Schwifty"),
        .package(path: "../Squanch")
    ],
    targets: [
        .target(
            name: "Pets",
            dependencies: [
                .product(name: "AppState", package: "AppState"),
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch")
            ]
        ),
        .testTarget(
            name: "PetsTests",
            dependencies: ["Pets"]
        )
    ]
)
