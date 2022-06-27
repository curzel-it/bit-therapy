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
        .package(path: "../Biosphere"),
        .package(path: "../DesignSystem"),
        .package(path: "../InAppPurchases"),
        .package(path: "../OnScreen"),
        .package(path: "../Pets"),
        .package(path: "../Schwifty"),
        .package(path: "../Squanch"),
        .package(path: "../Tracking")
    ],
    targets: [
        .target(
            name: "PetSelection",
            dependencies: [
                .product(name: "AppState", package: "AppState"),
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "InAppPurchases", package: "InAppPurchases"),
                .product(name: "OnScreen", package: "OnScreen"),
                .product(name: "Pets", package: "Pets"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch"),
                .product(name: "Tracking", package: "Tracking")
            ]
        )
    ]
)
