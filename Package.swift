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
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.1.1/CoreSDK.xcframework.zip",
	    checksum: "73902e2a79c37341235793c6bb011f80bf0e31d5332cea309684f15edc36144b"
	),
	.binaryTarget(
	    name: "DeviceInfoSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.1.1/DeviceInfoSDK.xcframework.zip",
	    checksum: "041ad9d9bc8a597399e933ad3a07cab5f191af89169c893ce54c1333bc912e26"
	),
	.binaryTarget(
	    name: "EnclaveSDK",
	    url: "https://packages.beyondidentity.com/public/bi-sdk-swift/raw/versions/0.1.1/EnclaveSDK.xcframework.zip",
	    checksum: "e4a7bf99a2e46412a0e87e234d8bce7141c4885f46fa6a49c5cb56a8f1116399"
	),
        .testTarget(
            name: "BISDKUnitTests",
            dependencies: ["Authenticator", "Embedded", "SharedDesign"],
            path: "Tests/UnitTests",
            exclude: []
        )
    ]
)
