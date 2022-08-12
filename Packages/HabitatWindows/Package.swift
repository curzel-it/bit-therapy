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
        .package(path: "../LiveEnvironment"),
        .package(path: "../Pets"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.0"),
        .package(path: "../Sprites"),
        .package(path: "../Squanch")
    ],
    targets: [
        .target(
            name: "HabitatWindows",
            dependencies: [
                .product(name: "AppState", package: "AppState"),
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "EntityWindow", package: "EntityWindow"),
                .product(name: "LiveEnvironment", package: "LiveEnvironment"),
                .product(name: "Pets", package: "Pets"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Sprites", package: "Sprites"),
                .product(name: "Squanch", package: "Squanch"),
                .product(name: "UfoAbduction", package: "UfoAbduction")
            ]
        ),
        .testTarget(
            name: "HabitatWindowsTests",
            dependencies: [
                "HabitatWindows",
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "LiveEnvironment", package: "LiveEnvironment")
            ]
        )
    ]
)
