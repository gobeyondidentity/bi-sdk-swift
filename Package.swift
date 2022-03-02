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
            dependencies: ["CoreSDK", "SharedDesign"],
            path: "Sources/Authenticator/"
        ),
        .target(
            name: "BeyondIdentityEmbedded",
            dependencies: ["CoreSDK"],
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
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.6.0/CoreSDK.xcframework.zip",
	    checksum: "b598d394bf8c4b8a584ee439a5c742937780d9904cc4cf28fd0705835bbe2891"
	),
        .testTarget(
            name: "UnitTests",
            dependencies: ["BeyondIdentityAuthenticator", "BeyondIdentityEmbedded", "SharedDesign"],
            path: "Tests/UnitTests",
            exclude: []
        )
    ]
)
