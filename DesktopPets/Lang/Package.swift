// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Lang",
    defaultLocalization: "en",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "Lang",
            targets: ["Lang"]
        )
    ],
    dependencies: [
        .package(path: "../AppState"),
        .package(path: "../../Pets")
    ],
    targets: [
        .target(
            name: "Lang",
            dependencies: [
                .product(name: "AppState", package: "AppState"),
                .product(name: "Pets", package: "Pets")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "LangTests",
            dependencies: ["Lang"]
        )
    ]
)
