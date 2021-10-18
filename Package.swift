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
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.2.2/CoreSDK.xcframework.zip",
	    checksum: "d2121e70ab889d83c6c9c84a2db9aaedb50a2b19f6fdbb3ad2eaccc3ebc4cbd8"
	),
	.binaryTarget(
	    name: "DeviceInfoSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.2.2/DeviceInfoSDK.xcframework.zip",
	    checksum: "04941af6dd23f47653799b6569577fe37534e3fadf6b81c4d6037b6a7d297395"
	),
	.binaryTarget(
	    name: "EnclaveSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.2.2/EnclaveSDK.xcframework.zip",
	    checksum: "3282b5835ee8919e0a33003daf4912140969c81ae3331f1b173580ac3655fa5d"
	),
        .testTarget(
            name: "BISDKUnitTests",
            dependencies: ["Authenticator", "Embedded", "SharedDesign"],
            path: "Tests/UnitTests",
            exclude: []
        )
    ]
)
