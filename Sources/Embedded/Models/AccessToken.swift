import Foundation

/// OAuth token grant
public struct AccessToken: Equatable {
    
    /// string value for the `AccessToken`
    public let value: String
    
    /// `AccessToken` type such as "Bearer"
    public let type: String
    
    /// `AccessToken` expiration
    public let expiresIn: Int
}
