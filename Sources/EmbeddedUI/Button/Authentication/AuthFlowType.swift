import BeyondIdentityEmbedded
import Foundation

/// Describes the auth flow that your app requires. If your app uses a backend to make a token exchange use `authorize`. If your app does not have a backend, use `authenticate`. Make sure to configure your client ID appropriately.
public enum AuthFlowType {
    /// An `authorize` FlowType assumes that your app uses a backend to make a token exchange and will return an `AuthorizationCode` on a successful response.
    /// - pkce: Optional but recommended to prevent authorization code injection. Use `createPKCE` to generate a `PKCE.CodeChallenge`.
    /// - scope: string list of OIDC scopes used during authentication to authorize access to a user's specific details. Only "openid" is currently supported.
    /// - callback:  accepts an `AuthorizationCode`
    case authorize(pkce: PKCE.CodeChallenge?, scope: String, callback: (AuthorizationCode) -> Void)
    
    /// An `authenticate` FlowType assumes that your app authenticates and authorizes the user by completing both the authorization flow and token exchange directly in your app.
    /// - callback: accepts a `TokenResponse`
    case authenticate(callback: (TokenResponse) -> Void)
}
