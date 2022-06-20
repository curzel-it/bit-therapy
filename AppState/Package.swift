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
        .package(path: "../DesignSystem")
    ],
    targets: [
        .target(
            name: "AppState",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem")
            ]
        )
    ]
)
