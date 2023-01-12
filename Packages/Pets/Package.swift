// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "Pets",
    platforms: [.macOS(.v11), .iOS(.v15)],
    products: [
        .library(
            name: "Pets",
            targets: ["Pets"]
        )
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../Yage"),
        .package(path: "../YageLive"),
        .package(url: "https://github.com/curzel-it/notagif", from: "1.0.4"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.16")
    ],
    targets: [
        .target(
            name: "Pets",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "NotAGif", package: "NotAGif"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Yage", package: "Yage"),
                .product(name: "YageLive", package: "YageLive")
            ]
        ),
        .testTarget(
            name: "PetsTests",
            dependencies: ["Pets"]
        )
    ]
)
