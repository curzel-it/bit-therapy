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
        .package(path: "../Pets"),
        .package(url: "https://github.com/curzel-it/desktop-kit", from: "1.0.12"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.3"),
        .package(url: "https://github.com/curzel-it/squanch", from: "1.0.2")
    ],
    targets: [
        .target(
            name: "OnScreen",
            dependencies: [
                .product(name: "AppState", package: "AppState"),
                .product(name: "DesktopKit", package: "desktop-kit"),
                .product(name: "Pets", package: "Pets"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch")
            ]
        ),
        .testTarget(
            name: "OnScreenTests",
            dependencies: [
                .product(name: "DesktopKit", package: "desktop-kit"),
                "OnScreen"
            ]
        )
    ]
)
