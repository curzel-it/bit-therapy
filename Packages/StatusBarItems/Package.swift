// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "StatusBarItems",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "StatusBarItems",
            targets: ["StatusBarItems"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "StatusBarItems",
            dependencies: [],
            resources: []
        )
    ]
)
