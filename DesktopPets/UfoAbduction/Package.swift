// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "UfoAbduction",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "UfoAbduction",
            targets: ["UfoAbduction"]
        )
    ],
    dependencies: [
        .package(path: "../AppState"),
        .package(path: "../../Biosphere"),
        .package(path: "../../Pets"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.0"),
        .package(path: "../../Sprites"),
        .package(path: "../../Squanch")
    ],
    targets: [
        .target(
            name: "UfoAbduction",
            dependencies: [
                .product(name: "AppState", package: "AppState"),
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "Pets", package: "Pets"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Sprites", package: "Sprites"),
                .product(name: "Squanch", package: "Squanch")
            ]
        ),
        .testTarget(
            name: "UfoAbductionTests",
            dependencies: ["UfoAbduction"]
        )
    ]
)
