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
        .package(path: "../EntityWindow"),
        .package(path: "../UfoAbduction"),
        .package(path: "../Biosphere"),
        .package(path: "../Pets"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.0"),
        .package(path: "../Squanch")
    ],
    targets: [
        .target(
            name: "HabitatWindows",
            dependencies: [
                .product(name: "AppState", package: "AppState"),
                .product(name: "Biosphere", package: "Biosphere"),
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
