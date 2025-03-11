// swift-tools-version:5.6

// THIS FILE IS GENERATED. DO NOT EDIT.
import PackageDescription

let package = Package(
    name: "BeyondIdentitySDKs",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "BeyondIdentityEmbedded",
            targets: ["BeyondIdentityEmbedded"]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "CoreSDK",
            url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/2.1.1/CoreSDK.xcframework.zip",
            checksum: "1e2771fe4b7cb1af8e1b7ee2cde2724b109b034d8bd77585b0042aacf5da8372"
        ),
        .target(
            name: "BeyondIdentityEmbedded",
            dependencies: ["CoreSDK"],
            path: "Sources/Embedded/"
        ),
    ]
)
