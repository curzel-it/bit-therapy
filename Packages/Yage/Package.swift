// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Yage",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "Yage",
            targets: ["Yage"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Yage",
            dependencies: []
        ),
        .testTarget(
            name: "YageTests",
            dependencies: ["Yage"]
        )
    ]
)
