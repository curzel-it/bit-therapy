// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "Dialogs",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Dialogs",
            targets: ["Dialogs"]
        )
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.0.12")
    ],
    targets: [
        .target(
            name: "Dialogs",
            dependencies: [
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "Schwifty", package: "Schwifty")
            ]
        ),
        .testTarget(
            name: "DialogsTests",
            dependencies: ["Dialogs"]
        )
    ]
)
