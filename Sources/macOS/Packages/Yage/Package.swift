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
        .package(url: "https://github.com/curzel-it/NotAGif", from: "1.0.8"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.1.1")
    ],
    targets: [
        .target(
            name: "Yage",
            dependencies: [
                .product(name: "NotAGif", package: "NotAGif"),
                .product(name: "Schwifty", package: "Schwifty")
            ]
        ),
        .testTarget(
            name: "YageTests",
            dependencies: [
                "Yage",
                .product(name: "Schwifty", package: "Schwifty")
            ]
        )
    ]
)
