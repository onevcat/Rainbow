// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Rainbow",
    products: [
        .library(name: "Rainbow", targets: ["Rainbow"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Rainbow", dependencies: [], path: "Sources"),
        .testTarget(name: "RainbowTests", dependencies: ["Rainbow"], path: "Tests"),
    ]
)
