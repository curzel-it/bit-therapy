// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "InAppPurchases",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "InAppPurchases",
            targets: ["InAppPurchases"]
        )
    ],
    dependencies: [
        .package(path: "../Tracking"),
        .package(path: "../Biosphere"),
        .package(path: "../Lang"),
        .package(url: "https://github.com/curzel-it/squanch", from: "1.0.0"),
        .package(url: "https://github.com/RevenueCat/purchases-ios", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "InAppPurchases",
            dependencies: [
                .product(name: "RevenueCat", package: "purchases-ios"),
                .product(name: "Biosphere", package: "Biosphere"),
                .product(name: "Lang", package: "Lang"),
                .product(name: "Squanch", package: "Squanch"),
                .product(name: "Tracking", package: "Tracking")
            ]
        )
    ]
)
