// swift-tools-version:4.0

import PackageDescription
let package = Package(
    name: "Rainbow",
    targets: [
        .target(name: "Rainbow", path: "Sources"),
        .testTarget(name: "RainbowTests", dependencies: ["Rainbow"], path: "Tests")
    ]
)
