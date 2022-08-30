// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Pets",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "Pets",
            targets: ["Pets"]
        )
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(url: "https://github.com/curzel-it/desktop-kit", from: "1.0.11"),
        .package(url: "https://github.com/curzel-it/notagif", from: "1.0.3"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.3"),
        .package(url: "https://github.com/curzel-it/squanch", from: "1.0.2")
    ],
    targets: [
        .target(
            name: "Pets",
            dependencies: [
                .product(name: "DesktopKit", package: "desktop-kit"),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "NotAGif", package: "NotAGif"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch")
            ],
            resources: [
                .copy("Assets")
            ]

        ),
        .testTarget(
            name: "PetsTests",
            dependencies: ["Pets"]
        )
    ]
)
