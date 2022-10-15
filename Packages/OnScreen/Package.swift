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
        .package(path: "../DesktopKit"),
        .package(path: "../Pets"),
        .package(path: "../Yage"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.3"),
        .package(url: "https://github.com/curzel-it/squanch", from: "1.0.6")
    ],
    targets: [
        .target(
            name: "OnScreen",
            dependencies: [
                .product(name: "AppState", package: "AppState"),
                .product(name: "DesktopKit", package: "DesktopKit"),
                .product(name: "Pets", package: "Pets"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch"),
                .product(name: "Yage", package: "Yage")
            ]
        ),
        .testTarget(
            name: "OnScreenTests",
            dependencies: [
                "OnScreen",
                .product(name: "DesktopKit", package: "DesktopKit"),
                .product(name: "Yage", package: "Yage")
            ]
        )
    ]
)
