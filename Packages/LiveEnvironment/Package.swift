// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "LiveEnvironment",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "LiveEnvironment",
            targets: ["LiveEnvironment"])
    ],
    dependencies: [
        .package(path: "../Biosphere"),
        .package(path: "../DesignSystem"),
        .package(path: "../Schwifty"),
        .package(path: "../Sprites"),
        .package(path: "../Squanch")
    ],
    targets: [
        .target(
            name: "LiveEnvironment",
            dependencies: [
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Sprites", package: "Sprites"),
                .product(name: "Squanch", package: "Squanch")
            ]),
        .testTarget(
            name: "LiveEnvironmentTests",
            dependencies: ["LiveEnvironment"]
        )
    ]
)

