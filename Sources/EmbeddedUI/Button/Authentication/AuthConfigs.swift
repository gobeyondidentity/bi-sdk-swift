import BeyondIdentityEmbedded
import Foundation


/// A `FlowType` tells Beyond Identity which authentication flow that your app requires. If your app uses a backend to make a token exchange use `authorize`. If your app does not have a backend, use `authenticate`.
public enum FlowType {
    /// An `authorize` FlowType assumes that your app uses a backend to make a token exchange and will return an `AuthorizationCode` on a successful response. Create an authorize FlowType with a `AuthorizeLoginConfig` and a callback that accepts an `AuthorizationCode`.
    case authorize(AuthorizeLoginConfig, (AuthorizationCode) -> Void)
    
    /// An `authenticate` FlowType assumes that your app authenticates and authorizes the user by completing both the authorization flow and token exchange directly in your app. Create an authenticate FlowType with a `AuthenticateLoginConfig` and a callback that accepts a `TokenResponse`.
    case authenticate(AuthenticateLoginConfig, (TokenResponse) -> Void)
}

protocol LoginConfig {
    var clientID: String { get }
    var redirectURI: String { get }
}

/// Use this config to create an authorize `FlowType`.
public struct AuthorizeLoginConfig: LoginConfig {
    /// The client ID generated during the OIDC configuration.
    public let clientID: String
    
    /// URI where the user will be redirected after the authorization has completed. The redirect URI must be one of the URIs passed in the OIDC configuration.
    public let redirectURI: String
    
    /// Optional but recommended to prevent authorization code injection. Use `createPKCE` to generate a `PKCE.CodeChallenge`.
    public let pkce: PKCE.CodeChallenge?
    
    /// string list of OIDC scopes used during authentication to authorize access to a user's specific details. Only "openid" is currently supported.
    public let scope: String
    
    public init(
        clientID: String,
        redirectURI: String,
        pkce: PKCE.CodeChallenge?,
        scope: String
    ){
        self.clientID = clientID
        self.redirectURI = redirectURI
        self.pkce = pkce
        self.scope = scope
    }
}

/// Use this config to create an authenticate `FlowType`.
public struct AuthenticateLoginConfig: LoginConfig {
    
    /// The client ID generated during the OIDC configuration.
    public let clientID: String
    
    /// URI where the user will be redirected after the authorization has completed. The redirect URI must be one of the URIs passed in the OIDC configuration.
    public let redirectURI: String
    
    public init(clientID: String, redirectURI: String){
        self.clientID = clientID
        self.redirectURI = redirectURI
    }
}
