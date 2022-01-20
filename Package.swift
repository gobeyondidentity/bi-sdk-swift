// swift-tools-version:5.3

// THIS FILE IS GENERATED. DO NOT EDIT.
import PackageDescription

let package = Package(
    name: "BeyondIdentitySDKs",
    defaultLocalization: "en",
    platforms: [.iOS(.v12), .macOS(.v10_15)],
    products: [
        .library(
            name: "BeyondIdentityAuthenticator",
            targets: ["BeyondIdentityAuthenticator"]),
        .library(
            name: "BeyondIdentityEmbedded",
            targets: ["BeyondIdentityEmbedded"]),
        .library(
            name: "BeyondIdentityEmbeddedUI",
            targets: ["BeyondIdentityEmbeddedUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/Rightpoint/Anchorage.git", from: "4.5.0"),
    ],
    targets: [
        .target(
            name: "BeyondIdentityAuthenticator",
            dependencies: ["CoreSDK", "DeviceInfoSDK", "EnclaveSDK", "SharedDesign"],
            path: "Sources/Authenticator/"
        ),
        .target(
            name: "BeyondIdentityEmbedded",
            dependencies: ["CoreSDK", "DeviceInfoSDK", "EnclaveSDK"],
            path: "Sources/Embedded/"
        ),
        .target(
            name: "BeyondIdentityEmbeddedUI",
            dependencies: ["Anchorage", "BeyondIdentityEmbedded", "SharedDesign"],
            path: "Sources/EmbeddedUI/"
         ),
        .target(
            name: "SharedDesign",
            path: "Sources/SharedDesign/",
            resources: [.process("Resources/Fonts")]
         ),
	.binaryTarget(
	    name: "CoreSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.5.0/CoreSDK.xcframework.zip",
	    checksum: "ad4d1a680b309d5fd693a93a5b64d9e890899e79d27818b6382642c59074c7ac"
	),
	.binaryTarget(
	    name: "DeviceInfoSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.5.0/DeviceInfoSDK.xcframework.zip",
	    checksum: "dbb7e4925c72a5d47278c190a1fef0c9efefbd2cd18dadb68294e0d34936d36c"
	),
	.binaryTarget(
	    name: "EnclaveSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.5.0/EnclaveSDK.xcframework.zip",
	    checksum: "f56436b087004cf6790a80b047f98fa5694a64e77fa75a7a02cdc8bdad91827c"
	),
        .testTarget(
            name: "UnitTests",
            dependencies: ["BeyondIdentityAuthenticator", "BeyondIdentityEmbedded", "SharedDesign"],
            path: "Tests/UnitTests",
            exclude: []
        )
    ]
)
