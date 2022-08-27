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
        .package(path: "../Lang"),
        .package(path: "../Tracking"),
        .package(url: "https://github.com/curzel-it/squanch", from: "1.0.2"),
        .package(url: "https://github.com/RevenueCat/purchases-ios", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "InAppPurchases",
            dependencies: [
                .product(name: "Lang", package: "Lang"),
                .product(name: "RevenueCat", package: "purchases-ios"),
                .product(name: "Squanch", package: "Squanch"),
                .product(name: "Tracking", package: "Tracking")
            ]
        )
    ]
)
