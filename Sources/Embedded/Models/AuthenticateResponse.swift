import CoreSDK
import Foundation

/// A response returned after successfully authenticating.
public struct AuthenticateResponse: Equatable, Hashable {
    /// The redirect URL that originates from the /authorize call's `redirect_uri` parameter.
    /// The OAuth2 authorization `code` and the `state` parameter of the /authorize call are attached with the "code" and "state" parameters to this URL.
    public let redirectUrl: URL
    /// An optional displayable message defined by policy returned by the cloud on success.
    public let message: String?
    /// An optional one-time-token returned from successful `redeemOtp` that may be redeemed for a credential_binding_link from the /credential-binding-jobs endpoint.
    public let passkeyBindingToken: String?
    
    public init(
        redirectUrl: URL,
        message: String?,
        passkeyBindingToken: String?
    ){
        self.redirectUrl = redirectUrl
        self.message = message
        self.passkeyBindingToken = passkeyBindingToken
    }
    
    init(_ response: CoreSDK.BiAuthenticateUrlResponse) {
        self.redirectUrl = response.redirectURL
        self.message = response.message
        self.passkeyBindingToken = response.passkeyBindingToken
    }
}

