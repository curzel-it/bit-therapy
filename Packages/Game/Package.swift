// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Game",
    platforms: [.macOS(.v11), .iOS(.v15)],
    products: [
        .library(
            name: "Game",
            targets: ["Game"]
        )
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../Pets"),
        .package(path: "../Yage"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.11")
    ],
    targets: [
        .target(
            name: "Game",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "Pets", package: "Pets"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Yage", package: "Yage")
            ]
        ),
        .testTarget(
            name: "GameTests",
            dependencies: ["Game"]
        )
    ]
)
