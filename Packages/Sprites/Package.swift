// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Sprites",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "Sprites",
            targets: ["Sprites"])
    ],
    dependencies: [
        .package(path: "../Biosphere"),
        .package(path: "../DesignSystem"),
        .package(path: "../Schwifty"),
        .package(path: "../Squanch")
    ],
    targets: [
        .target(
            name: "Sprites",
            dependencies: [
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch")
            ]),
        .testTarget(
            name: "SpritesTests",
            dependencies: ["Sprites"]
        )
    ]
)
