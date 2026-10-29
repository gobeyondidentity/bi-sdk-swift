import Foundation

// THIS FILE IS GENERATED.
let isGovEnvironment: Bool = false
let acme_cloud_base_url = "https://acme-cloud.byndid.com"

let tenant_gov = "0001b3d03c6f0b83"
let realm_gov = "8c1e82693c192b59"
let application_gov = "dfb75f55-f20f-496b-a6bc-98b88a3ffcbd"
let client_id_gov = "LIvW1Mb1xsW36QeOCNo3usYQ"
let bi_base_url_gov = "https://auth.us1.beyondidentity-gov.com"

var tenant: String { isGovEnvironment ? tenant_gov : "00012da391ea206d" }
var realm: String { isGovEnvironment ? realm_gov : "862e4b72cfdce072" }
var application: String { isGovEnvironment ? application_gov : "a8c0aa60-38e4-42b6-bd52-ef64aba5478b" }
var client_id: String { isGovEnvironment ? client_id_gov : "KhSWSmfhZ6xCMz9yw7DpJcv5" }
var bi_base_url: String { isGovEnvironment ? bi_base_url_gov : "https://auth-us.beyondidentity.com" }

// swiftlint:disable line_length
struct EmbeddedViewModel {
    let auth0Config = Auth0Config()
    
    /// Your crafted Beyond Identity Authorize URL
    let beyondIdentityAuth = URL(string: "\(bi_base_url)/v1/tenants/\(tenant)/realms/\(realm)/applications/\(application)/authorize?response_type=code&client_id=\(client_id)&redirect_uri=\("acme://".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&scope=openid&state=random_state")!
    
    /// Your crafter Beyond Identity Token URL
    let beyondIdentityToken = URL(string: "\(bi_base_url)/v1/tenants/\(tenant)/realms/\(realm)/applications/\(application)/token")!

    /// Prompt the user will see when exporting a passkey from one device to another
    let biometricAskPrompt = "Please verify it's really you before you can set up this passkey on another device."
    
    // This would be your backend endpoint to bind a passkey to device.
    let bindEndpoint = URL(string: "\(acme_cloud_base_url)/credential-binding-link")!
    
    let oktaConfig = OktaConfig()
    
    // This would be your backend endpoint to recover a passkey by username already bound to device.
    let recoverEndpoint = URL(string: "\(acme_cloud_base_url)/recover-credential-binding-link")!
    
    /// SDK version
    let sdkVersion = "2.2.0"
}

struct Auth0Config {
    let baseURL = URL(string: "https://dev-pt10fbkg.us.auth0.com")!
    let clientID = "q1cubQfeZWnajq5YkeZVD3NauRqU4vNs"
    let connection = "Example-App-Native"
    let redirectURI = "acme://auth0".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
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
    let redirectURI = "acme://okta".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
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