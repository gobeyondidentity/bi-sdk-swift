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
Currently, Beyond Identity only supports clients with a backend. This allows for two flows: 

1. [Cloud Handles Everything](#Cloud-Handles-Everything)  
Your backend is configured to handle getting the authorization code and exchanging that code for an access token and id token.

2. [Client And Cloud](#Client-And-Cloud)  
The client queries for the authorization code and your backend makes the token exchange.

For either flow you'll want to create and add an `AuthView` in your `ViewController`. This view contains both Beyond Identity Sign In and Sign Up buttons.

When the user taps the "Sign In" button, an instance of [ASWebAuthenticationSession](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession) is created and will start. A secure, embedded web view loads and displays the page, from which the user can authenticate. When the user taps "Sign Up" button the AuthView will trigger your sign up action. 

The `AuthView` accepts five parameters. This first four are parameters from [ASWebAuthenticationSession](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession).
- `url`: A URL with the http or https scheme pointing to the authentication webpage.
- `callbackURLScheme`: The custom URL scheme that the app expects in the callback URL.
- `completionHandler`: A completion handler the session calls when it completes successfully, or when the user cancels the session.
- `prefersEphemeralWebBrowserSession`: A Boolean value that indicates whether the session should ask the browser for a private authentication session. Set to true to request that the browser doesn’t share cookies or other browsing data between the authentication session and the user’s normal browser session. The value of this property is false by default.
- `signUpAction`: A closure triggered when the user taps the AuthView "Sign Up" button. Your sign up action should include a call to the Beyond Identity API to create a user credential as well as a way for the user to [download the Beyond Identity App](https://app.byndid.com/downloads) to store the credential associated with your app. 

> :warning: WARNING :warning:
Custom Schemes offer a potential attack as iOS allows any URL Scheme to be claimed by multiple apps and thus malicious apps can hijack sensitive data. 
When configuting `ASWebAuthenticationSession`
use a [Universal Link](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html) for the `callbackURLScheme` to mitigate risk.

### Cloud Handles Everything
In this scenerio your backend handles getting the authorization code and exchanging that for an access token and id token. 

It is up to the developer to decide how to invoke their backend in order to initiate the flow, as well as what the response would be. As an example, a response could be a session id associated with the authenticated user or the userinfo payload that was queried on the backend.

Initialize an `AuthView` with a `url` that points to the authentication webpage that you have configured in your cloud. A secure, embedded web view loads and displays the page, from which the user can authenticate. 

On completion, the service sends a callback `url` to the session with an authentication token or anything else you have configured your backend to send in that url.

For more details on configuring your backend, see the [Developer Docs](https://docs.byndid.com).

```swift
import BISDK

/*  ! WARNING !
    Custom Schemes offer a potential attack as iOS allows any 
    URL Scheme to be claimed by multiple apps and thus malicious 
    apps can hijack sensitive data. 
    
    To mitigate this risk, use Universal Links in your production app.
*/

let authView = AuthView(
    url: viewModel.cloudURL,
    callbackURLScheme: viewModel.urlScheme,
    completionHandler: { [weak self] url, error in
        if let error = error { self?.signInCallBack(.failure(error)) }
        if let url = url { self?.signInCallBack(.success(url)) }
    },
    signUpAction: signUpAction
)

view.addSubview(authView)
```

``` swift
func mySignUpAction() {
   <!-- call to Beyond Identity API to create a user -->
} 
```

### Client And Cloud
In this scenerio your client handles getting the authorization code by calling a Beyond Identity endpoint and your backend handles exchanging that code for an access token and id token. 

It is up to the developer to decide what the response would be for your backend. As an example, a response could be a session id associated with the authenticated user or the userinfo payload that was queried on the backend.

The Beyond Identity `/authorize` endpoint supports the following parameters:
* `client_id`: unique ID for a tenant's registered OIDC client.
* `redirect_uri`: must match one of the configured values for the client.
* `response_type`: Only `code` supported at this time.
* `scope`: must contain `openid` (except for OAuth2).
* `state`: random string that the client can use to maintain state between the request and the callback. 

Initialize an `AuthView` with a `url` that points to Beyond Identity's `/authorize` endpoint with the appropriate parameters. A secure, embedded web view loads and displays the page, from which the user can authenticate. 

On completion, the service sends a callback `url` to the session where you'll need to confirm the state parameter has not changed and then pass the code to your backend to exchange for an access token and id token.

For more details, see the [Developer Docs](https://docs.byndid.com).

```swift
import BISDK

/*  ! WARNING !
    Custom Schemes offer a potential attack as iOS allows any 
    URL Scheme to be claimed by multiple apps and thus malicious 
    apps can hijack sensitive data. 
    
    To mitigate this risk, use Universal Links in your production app.
*/

self.state = UUID().uuidString

var authorizeEndpoint = URLComponents(string: "https://auth.byndid.com/v2/authorize")!
authorizeEndpoint.queryItems = [
    URLQueryItem(name: "client_id", value: viewModel.kClientId),
    URLQueryItem(name: "redirect_uri", value: viewModel.urlScheme),
    URLQueryItem(name: "state", value: self.state),
    URLQueryItem(name: "response_type", value: "code"),
    URLQueryItem(name: "scope", value: "openid")
]

let authView = AuthView(
    url: authorizeEndpoint.url!,
    callbackURLScheme: nil,
    completionHandler: { url, error in
        if let error = error { print(error) }
        if let url = url { print(url) }
        
        guard let url = url, let currentState = url.queryParameters?["state"], 
            currentState == self.state! else {
            print("Incorrect state")
            return
        }

        guard let url = url, let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            components.queryItems?.first(where: { $0.name == "state" })?.value == self.state! else {
            print("Incorrect state")
            return
        }

        if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
            // call your backend to make token exchange
            print(code)
        }
    },
    signUpAction: signUpAction
)

view.addSubview(authView)
```

``` swift
func mySignUpAction() {
   <!-- call to Beyond Identity API to create a user -->
} 
```

## Sample App and Walkthrough

A sample apps is available to explore in [Example](https://github.com/byndid/bi-sdk-swift/tree/main/Example) for the Authenticator SDK. 

Most of the heavy lifting is delegated to the external Beyond Identity Authenticator App when integrating the Authenticator SDK. Try out the flow by creating an account with our demo app [Acme Pay](https://acme-app.byndid.com/). You'll need access to the App Store to download the Authenticator app.