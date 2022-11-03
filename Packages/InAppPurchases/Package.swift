// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "InAppPurchases",
    platforms: [.macOS(.v11), .iOS(.v15)],
    products: [
        .library(
            name: "InAppPurchases",
            targets: ["InAppPurchases"]
        )
    ],
    dependencies: [
        .package(path: "../Tracking"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.11"),
        .package(url: "https://github.com/RevenueCat/purchases-ios", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "InAppPurchases",
            dependencies: [
                .product(name: "RevenueCat", package: "purchases-ios"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Tracking", package: "Tracking")
            ]
        )
    ]
)
