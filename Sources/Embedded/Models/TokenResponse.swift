import CoreSDK
import Foundation

/// A structure containing the access token and id token after a successful authentication
public struct TokenResponse: Equatable {
    
    /// OAuth token grant
    public let accessToken: AccessToken
    
    /// OIDC JWT token grant
    public let idToken: String

    init(_ response: CoreSDK.TokenResponse) {
        accessToken = AccessToken(
            value: response.accessToken,
            type: response.tokenType,
            expiresIn: response.expiresIn
        )
        idToken = response.idToken
    }
}
