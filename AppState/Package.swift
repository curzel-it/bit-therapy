// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "AppState",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "AppState",
            targets: ["AppState"]
        )
    ],
    dependencies: [
        .package(path: "../Biosphere"),
        .package(path: "../DesignSystem")
    ],
    targets: [
        .target(
            name: "AppState",
            dependencies: [
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "DesignSystem", package: "DesignSystem")
            ]
        ),
        .testTarget(
            name: "AppStateTests",
            dependencies: ["AppState"]
        )
    ]
)
