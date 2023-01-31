// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "DependencyInjectionUtils",
    platforms: [.macOS(.v11), .iOS(.v15)],
    products: [
        .library(
            name: "DependencyInjectionUtils",
            targets: ["DependencyInjectionUtils"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject", from: "2.8.0")
    ],
    targets: [
        .target(
            name: "DependencyInjectionUtils",
            dependencies: [
                .product(name: "Swinject", package: "Swinject")
            ]
        )
    ]
)
