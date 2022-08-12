// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "PetSelection",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "PetSelection",
            targets: ["PetSelection"]
        )
    ],
    dependencies: [
        .package(path: "../AppState"),
        .package(path: "../InAppPurchases"),
        .package(path: "../OnScreen"),
        .package(path: "../Tracking"),
        .package(path: "../Biosphere"),
        .package(path: "../DesignSystem"),
        .package(path: "../LiveEnvironment"),
        .package(path: "../Pets"),
        .package(path: "../PetsAssets"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.0"),
        .package(path: "../Sprites"),
        .package(path: "../Squanch")
    ],
    targets: [
        .target(
            name: "PetSelection",
            dependencies: [
                .product(name: "AppState", package: "AppState"),
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "InAppPurchases", package: "InAppPurchases"),
                .product(name: "LiveEnvironment", package: "LiveEnvironment"),
                .product(name: "OnScreen", package: "OnScreen"),
                .product(name: "Pets", package: "Pets"),
                .product(name: "PetsAssets", package: "PetsAssets"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Sprites", package: "Sprites"),
                .product(name: "Squanch", package: "Squanch"),
                .product(name: "Tracking", package: "Tracking")
            ]
        )
    ]
)
