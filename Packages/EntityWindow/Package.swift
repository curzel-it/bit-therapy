// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "EntityWindow",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "EntityWindow",
            targets: ["EntityWindow"]
        )
    ],
    dependencies: [
        .package(path: "../AppState"),
        .package(path: "../Biosphere"),
        .package(path: "../DesignSystem"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.0"),
        .package(path: "../Squanch")
    ],
    targets: [
        .target(
            name: "EntityWindow",
            dependencies: [
                .product(name: "AppState", package: "AppState"),
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch")
            ]
        ),
        .testTarget(
            name: "EntityWindowTests",
            dependencies: [
                "EntityWindow",
                .product(name: "Biosphere", package: "Biosphere")
            ]
        )
    ]
)
