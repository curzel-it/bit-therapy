// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Biosphere",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(
            name: "Biosphere",
            targets: ["Biosphere"])
    ],
    dependencies: [
        .package(url: "https://github.com/curzel-it/notagif", from: "1.0.2"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.3"),
        .package(url: "https://github.com/curzel-it/squanch", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Biosphere",
            dependencies: [
                .product(name: "NotAGif", package: "NotAGif"),
                .product(name: "Squanch", package: "Squanch"),
                .product(name: "Schwifty", package: "Schwifty")
            ]),
        .testTarget(
            name: "BiosphereTests",
            dependencies: [
                "Biosphere",
                .product(name: "Squanch", package: "Squanch")
            ]
        )
    ]
)
