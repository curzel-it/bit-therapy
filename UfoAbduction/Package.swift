// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "UfoAbduction",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "UfoAbduction",
            targets: ["UfoAbduction"]
        )
    ],
    dependencies: [
        .package(path: "../AppState"),
        .package(path: "../Biosphere"),
        .package(path: "../DesignSystem"),
        .package(path: "../Pets"),
        .package(path: "../Schwifty"),
        .package(path: "../Squanch")
    ],
    targets: [
        .target(
            name: "UfoAbduction",
            dependencies: [
                .product(name: "AppState", package: "AppState"),
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "Pets", package: "Pets"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch")
            ]
        )
    ]
)
