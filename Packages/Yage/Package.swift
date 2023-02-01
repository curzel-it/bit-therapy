// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "Yage",
    platforms: [.macOS(.v11), .iOS(.v15)],
    products: [
        .library(
            name: "Yage",
            targets: ["Yage"]
        )
    ],
    dependencies: [
        .package(path: "../DependencyInjectionUtils"),
        .package(url: "https://github.com/curzel-it/NotAGif", from: "1.0.7"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.17")
    ],
    targets: [
        .target(
            name: "Yage",
            dependencies: [
                .product(name: "DependencyInjectionUtils", package: "DependencyInjectionUtils"),
                .product(name: "NotAGif", package: "NotAGif"),
                .product(name: "Schwifty", package: "Schwifty")
            ]
        ),
        .testTarget(
            name: "YageTests",
            dependencies: ["Yage"]
        )
    ]
)
