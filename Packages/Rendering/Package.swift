// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "Rendering",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "Rendering",
            targets: ["Rendering"]
        )
    ],
    dependencies: [
        .package(path: "../DependencyInjectionUtils"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.17")
    ],
    targets: [
        .target(
            name: "Rendering",
            dependencies: [
                .product(name: "DependencyInjectionUtils", package: "DependencyInjectionUtils"),
                .product(name: "Schwifty", package: "Schwifty")
            ]
        ),
        .testTarget(
            name: "RenderingTests",
            dependencies: ["Rendering"]
        )
    ]
)
