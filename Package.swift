// swift-tools-version:5.5

// THIS FILE IS GENERATED. DO NOT EDIT.
import PackageDescription

let package = Package(
    name: "BeyondIdentitySDKs",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "BeyondIdentityEmbedded",
            targets: ["BeyondIdentityEmbedded"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BeyondIdentityEmbedded",
            dependencies: ["CoreSDK"],
            path: "Sources/Embedded/"
        ),
	.binaryTarget(
	    name: "CoreSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/1.0.2/CoreSDK.xcframework.zip",
	    checksum: "a726426e215cbd3ddc8f8cea32b5a89cd1949b5dd5eddb4b8c9c14b8ea5215f5"
	),
        .testTarget(
            name: "UnitTests",
            dependencies: ["BeyondIdentityEmbedded"],
            path: "Tests/UnitTests",
            exclude: []
        )
    ]
)
