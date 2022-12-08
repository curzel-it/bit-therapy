// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "PetsAssets",
    platforms: [.macOS(.v11), .iOS(.v15)],
    products: [
        .library(
            name: "PetsAssets",
            targets: ["PetsAssets"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PetsAssets",
            dependencies: [],
            resources: [
                .copy("Assets")
            ]
        ),
        .testTarget(
            name: "PetsAssetsTests",
            dependencies: ["PetsAssets"]
        )
    ]
)
