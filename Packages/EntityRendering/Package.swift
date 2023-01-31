// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "EntityRendering",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "EntityRendering",
            targets: ["EntityRendering"]
        )
    ],
    dependencies: [
        .package(path: "../DependencyInjectionUtils"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.17")
    ],
    targets: [
        .target(
            name: "EntityRendering",
            dependencies: [
                .product(name: "DependencyInjectionUtils", package: "DependencyInjectionUtils"),
                .product(name: "Schwifty", package: "Schwifty")
            ]
        ),
        .testTarget(
            name: "EntityRenderingTests",
            dependencies: ["EntityRendering"]
        )
    ]
)
