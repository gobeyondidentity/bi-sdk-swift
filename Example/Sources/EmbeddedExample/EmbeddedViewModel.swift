import Foundation

// THIS FILE IS GENERATED.

// swiftlint:disable line_length
struct EmbeddedViewModel {
    /// Prompt the user will see when exporting a credential from one device to another
    let biometricAskPrompt = "Please verify it's really you before you can set up this credential on another device."
    
    /// SDK version
    let sdkVersion = "0.4.0"

    /// Your support URL
    let supportURL = URL(string: "mailto:acme@mail.com")!

    /// Client ID for the confidential client flow
    let confidentialClientID = "597c0a3c510b2afae53dc155d18933b5"

    /// Client ID for the public client flow
    let publicClientID = "9a1d484d3f00ed26e972127e05e42c43"

    /// This would ideally be a Universal Link
    let redirectURI = "acme://"

    // This would be your backend endpoint to recover an exisiting user.
    let recoverUserEndpoint = URL(string: "https://acme-cloud.byndid.com/recover-user")!

    // This would be your backend endpoint to register a new user.
    let registrationEndpoint = URL(string: "https://acme-cloud.byndid.com/users")!

    /// This is the endpoint your server would call to make the token exchange.
    let tokenEndpoint = URL(string: "https://auth.byndid.com/v2/token")!

    /// WARNING: This is only to demo what your server should do. Never store a client secret in your app.
    let confidentialClientSecret = "201866a137f9d3567f86dccdb3105764"
}
