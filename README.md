![Beyond-Identity-768x268](https://user-images.githubusercontent.com/6456218/111526630-5c826d00-8735-11eb-84ae-809af105b626.jpeg)

# Beyond Identity Swift SDKs

[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)

![version support](https://img.shields.io/badge/Version%20Support-iOS%2012%20and%20above-blueviolet)

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Goodbye, passwords!

## SDKs

### [Authenticator](https://developer.beyondidentity.com/docs/ios-swift-authenticator-sdk)

Passwordless authentication with our native platform Authenticator. The [Beyond Identity Authenticator](https://app.byndid.com/downloads) will need to be downloaded by your users.

### [Embedded](https://developer.beyondidentity.com/docs/ios-swift-embedded-sdk)

Passwordless authentication with our Authenticator embedded into your app. Users will not need to download the Beyond Identity Authenticator.

### [EmbeddedUI](https://developer.beyondidentity.com/docs/ios-swift-embedded-with-ui)

Passwordless authentication with our Authenticator embedded into your app with out of the box view wrappers.

## Installation

### Swift Package Manager

#### From Xcode

1. From the Xcode `File` menu, select `Swift Packages` » `Add Package Dependency` and add the following url:

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
