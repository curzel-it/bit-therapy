// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "GameMode",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "GameMode",
            targets: ["GameMode"]
        )
    ],
    dependencies: [
        .package(path: "../GameState"),
        .package(path: "../../Biosphere"),
        .package(path: "../../DesignSystem"),
        .package(path: "../../LiveEnvironment"),
        .package(path: "../../Pets"),
        .package(path: "../../PetsAssets"),
        .package(path: "../../Schwifty"),
        .package(path: "../../Squanch")
    ],
    targets: [
        .target(
            name: "GameMode",
            dependencies: [
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "GameState", package: "GameState"),
                .product(name: "LiveEnvironment", package: "LiveEnvironment"),
                .product(name: "Pets", package: "Pets"),
                .product(name: "PetsAssets", package: "PetsAssets"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch")
            ]
        ),
        .testTarget(
            name: "GameModeTests",
            dependencies: ["GameMode"]
        )
    ]
)
