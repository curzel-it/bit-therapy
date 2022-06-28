// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "HabitatWindows",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "HabitatWindows",
            targets: ["HabitatWindows"]
        )
    ],
    dependencies: [
        .package(path: "../AppState"),
        .package(path: "../Biosphere"),
        .package(path: "../DesignSystem"),
        .package(path: "../EntityWindow"),
        .package(path: "../Pets"),
        .package(path: "../Schwifty"),
        .package(path: "../Squanch"),
        .package(path: "../UfoAbduction")
    ],
    targets: [
        .target(
            name: "HabitatWindows",
            dependencies: [
                .product(name: "AppState", package: "AppState"),
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "EntityWindow", package: "EntityWindow"),
                .product(name: "Pets", package: "Pets"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch"),
                .product(name: "UfoAbduction", package: "UfoAbduction")
            ]
        ),
        .testTarget(
            name: "HabitatWindowsTests",
            dependencies: [
                "HabitatWindows",
                .product(name: "Biosphere", package: "Biosphere")
            ]
        )
    ]
)