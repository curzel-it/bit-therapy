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
        .package(path: "../Physics"),
        .package(path: "../Schwifty"),
        .package(path: "../Squanch")
    ],
    targets: [
        .target(
            name: "EntityWindow",
            dependencies: [
                .product(name: "AppState", package: "AppState"),
                .product(name: "Physics", package: "Physics"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch")
            ]
        )
    ]
)
