// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Rainbow",
    platforms: [
        .macOS(.v15),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
    ],
    products: [
        .library(name: "Rainbow", targets: ["Rainbow"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Rainbow", dependencies: [], path: "Sources"),
        .target(
            name: "RainbowPlayground",
            dependencies: ["Rainbow"],
            path:"Playground"
        ),
        .testTarget(name: "RainbowTests", dependencies: ["Rainbow"], path: "Tests"),
    ]
)
