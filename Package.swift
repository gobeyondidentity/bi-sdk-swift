// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "BISDK",
    defaultLocalization: "en",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "BISDK",
            targets: ["BISDK"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BISDK",
            path: "Source"
        ),
        .testTarget(
            name: "UnitTests",
            dependencies: ["BISDK"],
            path: "Tests/UnitTests"
        )
    ]
)
