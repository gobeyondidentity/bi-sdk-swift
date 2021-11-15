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
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.3.0/CoreSDK.xcframework.zip",
	    checksum: "40a4fe286a64d28986e321286536d01f8ba11208d26e97395a0c1ab4c187b712"
	),
	.binaryTarget(
	    name: "DeviceInfoSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.3.0/DeviceInfoSDK.xcframework.zip",
	    checksum: "dae6843cfecbe25f36cf73562ec0320798c09d2909d8e62a4db89cf45c65a3aa"
	),
	.binaryTarget(
	    name: "EnclaveSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.3.0/EnclaveSDK.xcframework.zip",
	    checksum: "7e12435c2b69f64cc03b712b9606f50df7da493daa4fcc2563ca3f3b84403ee8"
	),
        .testTarget(
            name: "UnitTests",
            dependencies: ["BeyondIdentityAuthenticator", "BeyondIdentityEmbedded", "SharedDesign"],
            path: "Tests/UnitTests",
            exclude: []
        )
    ]
)
