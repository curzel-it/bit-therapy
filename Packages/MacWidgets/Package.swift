// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "MacWidgets",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "MacWidgets",
            targets: ["MacWidgets"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.17")
    ],
    targets: [
        .target(
            name: "MacWidgets",
            dependencies: [
                .product(name: "Schwifty", package: "Schwifty")
            ]
        ),
        .testTarget(
            name: "MacWidgetsTests",
            dependencies: ["MacWidgets"]
        )
    ]
)
