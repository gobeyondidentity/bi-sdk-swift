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
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.4.0/CoreSDK.xcframework.zip",
	    checksum: "3fafb718bf063ab52634d15f134d44ecb43b17198b921df378da8fe21a5117f6"
	),
	.binaryTarget(
	    name: "DeviceInfoSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.4.0/DeviceInfoSDK.xcframework.zip",
	    checksum: "cdbe39a172800fef437080be38fd308b16bd76f42718101b54be090c3c335208"
	),
	.binaryTarget(
	    name: "EnclaveSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.4.0/EnclaveSDK.xcframework.zip",
	    checksum: "be62d2fc841fd328c3ae15d853c7b929fba7c969222bc710900f495e53d96e7c"
	),
        .testTarget(
            name: "UnitTests",
            dependencies: ["BeyondIdentityAuthenticator", "BeyondIdentityEmbedded", "SharedDesign"],
            path: "Tests/UnitTests",
            exclude: []
        )
    ]
)
