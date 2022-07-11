// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "GameState",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(
            name: "GameState",
            targets: ["GameState"]
        )
    ],
    dependencies: [
        .package(path: "../../Biosphere")
    ],
    targets: [
        .target(
            name: "GameState",
            dependencies: [
                .product(name: "Biosphere", package: "Biosphere")
            ]
        ),
        .testTarget(
            name: "GameStateTests",
            dependencies: ["GameState"]
        )
    ]
)
