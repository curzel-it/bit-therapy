// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "DesktopKit",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "DesktopKit",
            targets: ["DesktopKit"]
        )
    ],
    dependencies: [
        .package(path: "../Biosphere"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.3"),
        .package(url: "https://github.com/curzel-it/squanch", from: "1.0.0"),
        .package(url: "https://github.com/curzel-it/WindowsDetector", from: "1.0.3")
    ],
    targets: [
        .target(
            name: "DesktopKit",
            dependencies: [
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Squanch", package: "Squanch"),
                .product(name: "WindowsDetector", package: "WindowsDetector")
            ]
        ),
        .testTarget(
            name: "DesktopKitTests",
            dependencies: ["DesktopKit"]
        )
    ]
)
