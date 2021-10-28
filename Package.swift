// swift-tools-version:5.3

// THIS FILE IS GENERATED. DO NOT EDIT.
import PackageDescription

let package = Package(
    name: "BISDK",
    defaultLocalization: "en",
    platforms: [.iOS(.v12), .macOS(.v10_15)],
    products: [
        .library(
            name: "Authenticator",
            targets: ["Authenticator"]),
        .library(
            name: "Embedded",
            targets: ["Embedded"]),
        .library(
            name: "EmbeddedUI",
            targets: ["EmbeddedUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/Rightpoint/Anchorage.git", from: "4.5.0"),
    ],
    targets: [
        .target(
            name: "Authenticator",
            dependencies: ["CoreSDK", "DeviceInfoSDK", "EnclaveSDK", "SharedDesign"],
            path: "Sources/Authenticator/"
        ),
        .target(
            name: "Embedded",
            dependencies: ["CoreSDK", "DeviceInfoSDK", "EnclaveSDK"],
            path: "Sources/Embedded/"
        ),
        .target(
            name: "EmbeddedUI",
            dependencies: ["Anchorage", "Embedded", "SharedDesign"],
            path: "Sources/EmbeddedUI/"
         ),
        .target(
            name: "SharedDesign",
            path: "Sources/SharedDesign/",
            resources: [.process("Resources/Fonts")]
         ),
	.binaryTarget(
	    name: "CoreSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.2.3/CoreSDK.xcframework.zip",
	    checksum: "96a594ac66c3723bc21bc02d72e5ab8e58049ac6441d0e2d17159645cc33bd27"
	),
	.binaryTarget(
	    name: "DeviceInfoSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.2.3/DeviceInfoSDK.xcframework.zip",
	    checksum: "0c77ed659e0404eaa295bb1eb59aa0ce1d2a3079ae29b9dbfd69d43a2474b006"
	),
	.binaryTarget(
	    name: "EnclaveSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.2.3/EnclaveSDK.xcframework.zip",
	    checksum: "b7efbb7ae561c9d890166df9b2c08181b1a0dfd3424777e19665cb895b3da6ce"
	),
        .testTarget(
            name: "BISDKUnitTests",
            dependencies: ["Authenticator", "Embedded", "SharedDesign"],
            path: "Tests/UnitTests",
            exclude: []
        )
    ]
)
