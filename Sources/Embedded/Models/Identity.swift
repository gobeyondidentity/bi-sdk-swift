import CoreSDK
import Foundation

/// Identity information associated with a credential.
public struct Identity: Equatable {
    /// The display name of the identity.
    public let displayName: String
    /// The username of the identity.
    public let username: String
    
    public init(displayName: String, username: String){
        self.displayName = displayName
        self.username = username
    }
    
    init(_ identity: CoreSDK.Identity) {
        displayName = identity.displayName
        username = identity.username
    }
}
