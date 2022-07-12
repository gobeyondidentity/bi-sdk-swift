// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedDesign",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SharedDesign",
            targets: ["SharedDesign"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Rightpoint/Anchorage.git", from: "4.5.0"),
    ],
    targets: [
        .target(
            name: "SharedDesign",
            dependencies: ["Anchorage"],
            path: "Sources/SharedDesign/",
            resources: [.process("Resources/")]
        ),
        .testTarget(
            name: "SharedDesignTests",
            dependencies: ["SharedDesign"]),
    ]
)
