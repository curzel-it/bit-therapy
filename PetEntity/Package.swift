// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "PetEntity",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "PetEntity",
            targets: ["PetEntity"]
        )
    ],
    dependencies: [
        .package(path: "../AppState"),
        .package(path: "../DesignSystem"),
        .package(path: "../Pets"),
        .package(path: "../Biosphere"),
        .package(path: "../Schwifty"),
        .package(path: "../Squanch")
    ],
    targets: [
        .target(
            name: "PetEntity",
            dependencies: [
                .product(name: "AppState", package: "AppState"),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "Pets", package: "Pets"),
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch")
            ]
        )
    ]
)
