// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "Game",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Game",
            targets: ["Game"]
        )
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../Dialogs"),
        .package(path: "../Pets"),
        .package(path: "../Yage"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.12")
    ],
    targets: [
        .target(
            name: "Game",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "Dialogs", package: "Dialogs"),
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
