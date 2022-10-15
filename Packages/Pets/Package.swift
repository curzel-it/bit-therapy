// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Pets",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(
            name: "Pets",
            targets: ["Pets"]
        )
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../Yage"),
        .package(url: "https://github.com/curzel-it/notagif", from: "1.0.3"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.3"),
        .package(url: "https://github.com/curzel-it/squanch", from: "1.0.6")
    ],
    targets: [
        .target(
            name: "Pets",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "NotAGif", package: "NotAGif"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch"),
                .product(name: "Yage", package: "Yage")
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
