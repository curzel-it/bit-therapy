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
        .package(url: "https://github.com/curzel-it/squanch", from: "1.0.1")
    ],
    targets: [
        .target(
            name: "Biosphere",
            dependencies: [
                .product(name: "Squanch", package: "Squanch")
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
