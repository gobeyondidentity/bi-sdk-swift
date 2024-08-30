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
            url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/2.0.2/CoreSDK.xcframework.zip",
            checksum: "beaedba47b6294347f408fe0dcde868a402a6539de29e4b7fc432fab13302749"
        ),
        .target(
            name: "BeyondIdentityEmbedded",
            dependencies: ["CoreSDK"],
            path: "Sources/Embedded/"
        ),
    ]
)
