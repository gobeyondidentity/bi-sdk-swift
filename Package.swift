// swift-tools-version:5.5

// THIS FILE IS GENERATED. DO NOT EDIT.
import PackageDescription

let package = Package(
    name: "BeyondIdentitySDKs",
    defaultLocalization: "en",
    platforms: [.iOS(.v12), .macOS(.v10_15)],
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
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/1.0.1/CoreSDK.xcframework.zip",
	    checksum: "6130d43b654fcf4e208885fb1e6cddf81bc280d9ab696ecfce35f51b8abb1e44"
	),
        .testTarget(
            name: "UnitTests",
            dependencies: ["BeyondIdentityEmbedded"],
            path: "Tests/UnitTests",
            exclude: []
        )
    ]
)
