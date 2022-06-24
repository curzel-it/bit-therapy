// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "OnScreen",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "OnScreen",
            targets: ["OnScreen"]
        )
    ],
    dependencies: [
        .package(path: "../AppState"),
        .package(path: "../Biosphere"),
        .package(path: "../DesignSystem"),
        .package(path: "../Pets"),
        .package(path: "../Schwifty"),
        .package(path: "../Squanch"),
        .package(path: "../UfoAbduction")
    ],
    targets: [
        .target(
            name: "OnScreen",
            dependencies: [
                .product(name: "AppState", package: "AppState"),
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "Pets", package: "Pets"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch"),
                .product(name: "UfoAbduction", package: "UfoAbduction")
            ]
        ),
        .testTarget(
            name: "OnScreenTests",
            dependencies: []
        )
    ]
)
