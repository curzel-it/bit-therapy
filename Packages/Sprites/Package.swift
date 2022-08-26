// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Sprites",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "Sprites",
            targets: ["Sprites"]
        )
    ],
    dependencies: [
        .package(path: "../Biosphere"),
        .package(url: "https://github.com/curzel-it/notagif", from: "1.0.3"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.3"),
        .package(url: "https://github.com/curzel-it/squanch", from: "1.0.1")
    ],
    targets: [
        .target(
            name: "Sprites",
            dependencies: [
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "NotAGif", package: "NotAGif"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch")
            ]
        ),
        .testTarget(
            name: "SpritesTests",
            dependencies: ["Sprites"]
        )
    ]
)
