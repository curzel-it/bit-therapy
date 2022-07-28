// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"])
    ],
    dependencies: [
        .package(path: "../Squanch"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
                .product(name: "Squanch", package: "Squanch"),
                .product(name: "Schwifty", package: "Schwifty")
            ]
        )
    ]
)
