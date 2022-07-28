// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "PetsAssets",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(
            name: "PetsAssets",
            targets: ["PetsAssets"]
        )
    ],
    dependencies: [
        .package(path: "../Biosphere"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.0"),
        .package(path: "../Sprites"),
        .package(path: "../Squanch")
    ],
    targets: [
        .target(
            name: "PetsAssets",
            dependencies: [
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Sprites", package: "Sprites"),
                .product(name: "Squanch", package: "Squanch")
            ],
            resources: [
                .copy("PixelArt")
            ]
        ),
        .testTarget(
            name: "PetsAssetsTests",
            dependencies: ["PetsAssets"]
        )
    ]
)
