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
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.2.0/CoreSDK.xcframework.zip",
	    checksum: "3571c888885065a5e654037440a0e90ba63814d9c3f7161a2fd1db672a990513"
	),
	.binaryTarget(
	    name: "DeviceInfoSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.2.0/DeviceInfoSDK.xcframework.zip",
	    checksum: "1d2fcb73184de14493f0345849f81d50d6cdf0213784ab853afc3a7d2d2a486c"
	),
	.binaryTarget(
	    name: "EnclaveSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.2.0/EnclaveSDK.xcframework.zip",
	    checksum: "a7328edf0ef1149cd24f475632a15c60a29a62d584c367679cc5903801f31b44"
	),
        .testTarget(
            name: "BISDKUnitTests",
            dependencies: ["Authenticator", "Embedded", "SharedDesign"],
            path: "Tests/UnitTests",
            exclude: []
        )
    ]
)
