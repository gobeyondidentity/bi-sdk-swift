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
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/1.0.3/CoreSDK.xcframework.zip",
	    checksum: "b447b5fcb88441d15afc2bb7f200c1bcf0e113ddc16c4f98b0e0849f5d0678e9"
	),
        .testTarget(
            name: "UnitTests",
            dependencies: ["BeyondIdentityEmbedded"],
            path: "Tests/UnitTests",
            exclude: []
        )
    ]
)
