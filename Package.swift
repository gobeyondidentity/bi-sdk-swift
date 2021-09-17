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
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.1.0/CoreSDK.xcframework.zip",
	    checksum: "f5fa0b250db511e4a885b4922dbae0483e2a32ac372fdb491037b91baefb19a3"
	),
	.binaryTarget(
	    name: "DeviceInfoSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.1.0/DeviceInfoSDK.xcframework.zip",
	    checksum: "9531cafd69967837a774aa93275ee0a84fc38882a4e5501e1d37159524c93c27"
	),
	.binaryTarget(
	    name: "EnclaveSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.1.0/EnclaveSDK.xcframework.zip",
	    checksum: "b100bf89b2916a97eaec5bbc24201df4672e9815e895d2d4617525d91023e757"
	),
        .testTarget(
            name: "BISDKUnitTests",
            dependencies: ["Authenticator", "Embedded", "SharedDesign"],
            path: "Tests/UnitTests",
            exclude: []
        )
    ]
)
