<p align="center">
   <br/>
   <a href="https://developers.beyondidentity.com" target="_blank"><img src="https://user-images.githubusercontent.com/238738/178780350-489309c5-8fae-4121-a20b-562e8025c0ee.png" width="150px" ></a>
   <h3 align="center">Beyond Identity</h3>
   <p align="center">Universal Passkeys for Developers</p>
   <p align="center">
   All devices. Any protocol. Zero shared secrets.
   </p>
</p>

# Beyond Identity Swift SDK

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

![version support](https://img.shields.io/badge/Version%20Support-iOS%2013%20and%20above-blueviolet)

[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)

[![Cocoapods compatible](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg?style=flat)](https://cocoapods.org)

### Embedded SDK

Goodbye, passwords! The Beyond Identity SDKs allow you to embed the Passwordless experience into your product. A set of functions are provided to you through the Embedded namespace. These SDKs supports OIDC and OAuth 2.0.

## Installation

### Swift Package Manager

#### From Xcode

1. From the Xcode `File` menu, select `Add Packages` and add the following url:

```
https://github.com/gobeyondidentity/bi-sdk-swift
```

2. Select a version and hit Next.
3. Select a target matching the SDK you wish to use.

#### From Package.swift

1. With [Swift Package Manager](https://swift.org/package-manager),
   add the following `dependency` to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/gobeyondidentity/bi-sdk-swift.git", from: [version])
]
```

2. Run `swift build`

### Cocoapods

Add the pod to your Podfile:

```swift
pod 'BeyondIdentityEmbedded'
```

And then run:

```swift
pod install
```

After installing import with

```swift
import BeyondIdentityEmbedded
```

## Usage

Check out the [Developer Documentation](https://developer.beyondidentity.com) and the [SDK API Documentation](https://gobeyondidentity.github.io/bi-sdk-swift/documentation/beyondidentityembedded/) for more information.

### Setup

First, before calling the Embedded functions, make sure to initialize the SDK.

```swift
import BeyondIdentityEmbedded

Embedded.initialize(
    allowedDomains: [String] = ["beyondidentity.com", "byndid.com"],
    biometricAskPrompt: String,
    logger: ((OSLogType, String) -> Void)? = nil,
    callback: @escaping(Result<Void, BISDKError>) -> Void
)
```
