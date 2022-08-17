// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Lang",
    defaultLocalization: "en",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(
            name: "Lang",
            targets: ["Lang"]
        )
    ],
    dependencies: [
        .package(path: "../Pets")
    ],
    targets: [
        .target(
            name: "Lang",
            dependencies: [
                .product(name: "Pets", package: "Pets")
            ]
        )
    ]
)
