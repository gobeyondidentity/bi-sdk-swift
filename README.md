# authenticator-ios-sdk


## Setup

### Swift Package Manager

With [Swift Package Manager](https://swift.org/package-manager), 
add the following `dependency` to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/byndid/bi-sdk-swift.git", .upToNextMajor(from: "0.0.1"))
]
```
### CocoaPods

With [CocoaPods](https://guides.cocoapods.org/using/getting-started.html),
add the following line to your `Podfile`:

    pod 'BISDK'

Then, run `pod install`.

Use the `Authenticator` subspec:

    pod 'BISDK/Authenticator'
    
Use the `Embedded` subspec:

    pod 'BISDK/Embedded'

### Carthage

With [Carthage](https://github.com/Carthage/Carthage), add the following
line to your `Cartfile`:

    github "byndid/bi-sdk-swift" "master"

Then, run `carthage bootstrap`.
