// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Coordinator",
    platforms: [.iOS(.v16), .macOS(.v13), .macCatalyst(.v16), .tvOS(.v16), .watchOS(.v9)],
    products: [
        .library(
            name: "Coordinator",
            targets: ["Coordinator"]
        ),
    ],
    targets: [
        .target(
            name: "Coordinator"),
        .testTarget(
            name: "CoordinatorTests",
            dependencies: ["Coordinator"]
        ),
    ]
)
