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
            url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/2.0.5/CoreSDK.xcframework.zip",
            checksum: "39c5a65b9ecefc2ce3e13fe2971f361e889c182ed67eba42e000fdb342d7dd75"
        ),
        .target(
            name: "BeyondIdentityEmbedded",
            dependencies: ["CoreSDK"],
            path: "Sources/Embedded/"
        ),
    ]
)
