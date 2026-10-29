// swift-tools-version:5.6

// THIS FILE IS GENERATED. DO NOT EDIT.
import PackageDescription

let package = Package(
    name: "BeyondIdentitySDKs",
    defaultLocalization: "en",
    platforms: [.iOS(.v15)],
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
            url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/2.2.0/CoreSDK.xcframework.zip",
            checksum: "17d8bd8cbe1ec3b809c7cb31147a0d9389c614a5a4fa7d84d446e7039eac3926"
        ),
        .target(
            name: "BeyondIdentityEmbedded",
            dependencies: ["CoreSDK"],
            path: "Sources/Embedded/"
        ),
    ]
)
