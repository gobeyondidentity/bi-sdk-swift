![Beyond-Identity-768x268](https://user-images.githubusercontent.com/6456218/111526630-5c826d00-8735-11eb-84ae-809af105b626.jpeg)

# Beyond Identity Swift SDKs
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)


## SDKs
### Authenticator
The authenticator SDK will be used in conjunction with the existing Beyond Identity Authenticator for native clients Android, iOS, macOS, Windows, where most of the heavy lifting will be left up to them.

### Embedded
WIP: This will be a holistic SDK solution for CIAM clients, offering the entire experience embedded in their product.

## Specifications
### Supported Versions
The Authenticator supports iOS 12 and above

### Authorization Server Requirements
Authorization servers should not require clients maintain client secrets. Clients should opt for Universal Links as a redirect. PCKE support is comming soon to mitigate risk using a Custom URL Scheme.

## Setup
### Carthage

With [Carthage](https://github.com/Carthage/Carthage), add the following
line to your `Cartfile`:

    github "byndid/bi-sdk-swift" "main"

Run `carthage update --use-xcframeworks`.
 
Then, drag the built `.xcframework` bundles from `Carthage/Build` into the `"Frameworks and Libraries"` section of your application’s Xcode project.

### Swift Package Manager

With [Swift Package Manager](https://swift.org/package-manager), 
add the following `dependency` to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/byndid/bi-sdk-swift.git", .branch("main"))
]
```
Run `swift build`

<!-- ### CocoaPods

With [CocoaPods](https://guides.cocoapods.org/using/getting-started.html),
add the following line to your `Podfile`:

    pod 'BISDK'

Then, run `pod install`.

Use the `Authenticator` subspec:

    pod 'BISDK/Authenticator'
    
Use the `Embedded` subspec:

    pod 'BISDK/Embedded'
 -->


## Usage
In your ViewController, create and add an `AuthView`. This view contains both Beyond Identity Sign In and Sign Up buttons.

Configure an [ASWebAuthenticationSession](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession) instance to authenticate a user. 

Initialize the session with a URL that points to the authentication webpage that you have configured in your cloud. A secure, embedded web view loads and displays the page, from which the user can authenticate. 

On completion, the service sends a callback URL to the session with an authentication token, and the session passes this URL back to the app through a completion handler. Use a [Universal Link](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html) for the `callbackURLScheme` as there are potential risks using a Custom URL Scheme. See the warning in the code block below.

When the user taps the "Sign In" button, your session will start. When the user taps "Sign Up" button the AuthView will trigger your sign up action. 

Your sign up action should include a call to the Beyond Identity API to create a user credential as well as a way for the user to [download the Beyond Identity App](https://app.byndid.com/downloads) to store the credential associated with your app. 

For more details, see the [Developer Docs](https://docs.byndid.com).

```swift
import AuthenticationServices
import BISDK

/*  ! WARNING !
    Custom Schemes offer a potential attack as iOS allows any 
    URL Scheme to be claimed by multiple apps and thus malicious 
    apps can hijack sensitive data. 
    
    To mitigate this risk, use Universal Links in your production app.
    
    PKCE support is comming soon.
*/

let session = ASWebAuthenticationSession(
    url: viewModel.ACME_CLOUD_URL,
    callbackURLScheme: viewModel.ACME_URL_SCHEME,
    completionHandler: { url, error in
        if let error = error { print(error) }
        if let url = url { print(url) }
    }
)
```

``` swift
func mySignUpAction() {
   <!-- call to Beyond Identity API to create a user -->
} 
```

``` swift
let authView = AuthView(session: session, signUpAction: mySignUpAction)

view.addSubview(authView)
```

## Sample App and Walkthrough

A sample apps is available to explore in [Example](https://github.com/byndid/bi-sdk-swift/tree/main/Example) for the Authenticator SDK. 

Most of the heavy lifting is delegated to the external Beyond Identity Authenticator App when integrating the Authenticator SDK. Try out the flow by creating an account with our demo app [Acme Pay](https://acme-app.byndid.com/). You'll need access to the App Store to download the Authenticator app.