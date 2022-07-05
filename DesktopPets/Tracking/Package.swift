// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Tracking",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "Tracking",
            targets: ["Tracking"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "8.15.0"),
        .package(path: "../../Lang"),
        .package(path: "../../Pets"),
        .package(path: "../../Squanch")
    ],
    targets: [
        .target(
            name: "Tracking",
            dependencies: [
                .product(name: "FirebaseAnalyticsWithoutAdIdSupport", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseInstallations", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
                .product(name: "Lang", package: "Lang"),
                .product(name: "Pets", package: "Pets"),
                .product(name: "Squanch", package: "Squanch")
            ]
        )
    ]
)
