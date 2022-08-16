// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Geometry",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(
            name: "Geometry",
            targets: ["Geometry"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Geometry",
            dependencies: []),
        .testTarget(
            name: "GeometryTests",
            dependencies: ["Geometry"]
        )
    ]
)
