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
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/1.0.4/CoreSDK.xcframework.zip",
	    checksum: "63a1f0de1ec5640597e9b408da159fceaba52c56705a154227e79ebb83194cc9"
	),
        .testTarget(
            name: "UnitTests",
            dependencies: ["BeyondIdentityEmbedded"],
            path: "Tests/UnitTests",
            exclude: []
        )
    ]
)
