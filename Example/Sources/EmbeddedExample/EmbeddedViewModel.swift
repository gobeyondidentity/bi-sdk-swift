import Foundation

// THIS FILE IS GENERATED.

// swiftlint:disable line_length
struct EmbeddedViewModel {
    let auth0Config = Auth0Config()
    
    /// Your crafted Beyond Identity Authorize URL
    let beyondIdentityAuth = URL(string: "https://auth-us.beyondidentity.com/v1/tenants/00012da391ea206d/realms/862e4b72cfdce072/applications/3d869893-08b1-46ca-99c7-3c12226edf1b/authorize?response_type=code&client_id=JvV5DbxFZbana_tMTAPTs-gY&redirect_uri=acme%3A%2F%2F&scope=openid&state=random_state")!
    
    /// Prompt the user will see when exporting a credential from one device to another
    let biometricAskPrompt = "Please verify it's really you before you can set up this credential on another device."
    
    // This would be your backend endpoint to bind a credential to device.
    let bindEndpoint = URL(string: "https://acme-cloud.byndid.com/credential-binding-link")!
    
    let oktaConfig = OktaConfig()
    
    // This would be your backend endpoint to recover a credential by username already bound to device.
    let recoverEndpoint = URL(string: "https://acme-cloud.byndid.com/recover-credential-binding-link")!
    
    /// SDK version
    let sdkVersion = "1.0.4"
}

struct Auth0Config {
    let baseURL = URL(string: "https://dev-pt10fbkg.us.auth0.com")!
    let clientID = "q1cubQfeZWnajq5YkeZVD3NauRqU4vNs"
    let connection = "Example-App-Native"
    let redirectURI = "acme%3A%2F%2Fdev"
    let scopes = "openid"
    
    /// Your crafted Auth0 Authorize URL
    var generateAuthURL: URL {
        return URL(string: "\(baseURL)/authorize?connection=\(connection)&scope=\(scopes)&response_type=code&state=some_random_state&redirect_uri=\(redirectURI)&client_id=\(clientID)&nonce=nonce")!
    }
    
    /// Your Auth0 Token URL
    var tokenBaseURL: URL {
        return URL(string: "\(baseURL)/oauth/token")!
    }
}

struct OktaConfig {
    let baseURL = URL(string: "https://dev-43409302.okta.com/oauth2")!
    let clientID = "0oa5kipb8rdo4WCkf5d7"
    let idP = "0oa5rswruxTaPUcgl5d7"
    let redirectURI = "acme%3A%2F"
    let scopes = "openid"
    
    /// Your crafted Okta Authorize URL
    var generateAuthURL: URL {
        return URL(string: "\(baseURL)/v1/authorize?idp=\(idP)&scope=\(scopes)&response_type=code&state=some_random_state&redirect_uri=\(redirectURI)&client_id=\(clientID)")!
    }
    
    /// Your Okta Token URL
    var tokenBaseURL: URL {
        return URL(string: "\(baseURL)/v1/token?client_id=\(clientID)&redirect_uri=\(redirectURI)")!
    }
}