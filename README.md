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

Goodbye, passwords! The Beyond Identity SDKs allow you to embed the Passwordless experience into your product. These SDKs supports OIDC and OAuth2.

## [Embedded SDK](https://developer.beyondidentity.com/docs/v1/sdks/swift-sdk/overview)

Passwordless authentication with our Authenticator embedded into your app. Users will not need to download the Beyond Identity Authenticator.

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

Check out the [documentation](https://developer.beyondidentity.com) for more information.
