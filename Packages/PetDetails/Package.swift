// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "PetDetails",
    platforms: [.macOS(.v11), .iOS(.v15)],
    products: [
        .library(
            name: "PetDetails",
            targets: ["PetDetails"]
        )
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../InAppPurchases"),
        .package(path: "../Pets"),
        .package(path: "../Tracking"),
        .package(url: "https://github.com/curzel-it/notagif", from: "1.0.4"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.11")
    ],
    targets: [
        .target(
            name: "PetDetails",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "InAppPurchases", package: "InAppPurchases"),
                .product(name: "NotAGif", package: "NotAGif"),
                .product(name: "Pets", package: "Pets"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Tracking", package: "Tracking")
            ]
        ),
        .testTarget(
            name: "PetDetailsTests",
            dependencies: ["PetDetails"]
        )
    ]
)
