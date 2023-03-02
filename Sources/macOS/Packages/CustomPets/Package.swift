// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "CustomPets",
    platforms: [.macOS(.v11), .iOS(.v15)],
    products: [
        .library(
            name: "CustomPets",
            targets: ["CustomPets"]
        )
    ],
    dependencies: [
        .package(path: "../DependencyInjectionUtils"),
        .package(url: "https://github.com/curzel-it/schwifty", from: "1.1.1"),
        .package(url: "https://github.com/Swinject/Swinject", from: "2.8.0"),
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.9")
    ],
    targets: [
        .target(
            name: "CustomPets",
            dependencies: [
                .product(name: "DependencyInjectionUtils", package: "DependencyInjectionUtils"),
                .product(name: "Schwifty", package: "Schwifty"),
                .product(name: "Swinject", package: "Swinject"),
                .product(name: "ZIPFoundation", package: "ZIPFoundation")
            ]
        )
    ]
)
