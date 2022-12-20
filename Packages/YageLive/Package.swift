// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "YageLive",
    platforms: [.macOS(.v11), .iOS(.v15)],
    products: [
        .library(
            name: "YageLive",
            targets: ["YageLive"]
        )
    ],
    dependencies: [
        .package(path: "../Yage"),
        .package(url: "https://github.com/curzel-it/NotAGif", from: "1.0.7"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.13")
    ],
    targets: [
        .target(
            name: "YageLive",
            dependencies: [
                .product(name: "NotAGif", package: "NotAGif"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Yage", package: "Yage")
            ]
        ),
        .testTarget(
            name: "YageLiveTests",
            dependencies: ["YageLive"]
        )
    ]
)
