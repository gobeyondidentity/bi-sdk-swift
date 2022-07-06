import CoreSDK
import Foundation

/// A response returned after successfully authenticating.
public struct AuthenticateResponse: Equatable {
    /// The redirect URL that originates from the /authorize call's `redirect_uri` parameter.
    /// The OAuth 2 authorization `code` and the `state` parameter of the /authorize call are attached with the "code" and "state" parameters to this URL.
    public let redirectURL: URL
    /// An optional displayable message defined by policy returned by the cloud on success
    public let message: String?
    
    public init(
        redirectURL: URL,
        message: String?
    ){
        self.redirectURL = redirectURL
        self.message = message
    }
    
    init(_ response: CoreSDK.BiAuthenticateResponse) {
        self.redirectURL = response.redirectURL
        self.message = response.message
    }
}
