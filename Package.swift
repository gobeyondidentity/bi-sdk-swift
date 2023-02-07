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
            url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/2.0.0/CoreSDK.xcframework.zip",
            checksum: "3c926116baf1a6974a98a74c4752f523f54ec557a64f99a309b4b5e134fca8ea"
        ),
        .target(
            name: "BeyondIdentityEmbedded",
            dependencies: ["CoreSDK"],
            path: "Sources/Embedded/"
        ),
        .testTarget(
            name: "UnitTests",
            dependencies: ["BeyondIdentityEmbedded"],
            path: "Tests/UnitTests",
            exclude: []
        ),
    ]
)
