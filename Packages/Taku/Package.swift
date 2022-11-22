// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Taku",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "Taku",
            targets: ["Taku"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Taku",
            dependencies: []),
        .testTarget(
            name: "TakuTests",
            dependencies: ["Taku"]
        )
    ]
)
