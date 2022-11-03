// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "OnScreen",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "OnScreen",
            targets: ["OnScreen"]
        )
    ],
    dependencies: [
        .package(path: "../Pets"),
        .package(path: "../Yage"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.11"),
        .package(url: "https://github.com/curzel-it/windowsdetector", from: "1.0.3")
    ],
    targets: [
        .target(
            name: "OnScreen",
            dependencies: [
                .product(name: "Pets", package: "Pets"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "WindowsDetector", package: "WindowsDetector"),
                .product(name: "Yage", package: "Yage")
            ]
        ),
        .testTarget(
            name: "OnScreenTests",
            dependencies: [
                "OnScreen",
                .product(name: "Yage", package: "Yage")
            ]
        )
    ]
)
