import CoreSDK
import Foundation

/// Identity information associated with a credential.
public struct Identity: Equatable, Hashable {
    /// The display name of the identity.
    public let displayName: String
    /// The username of the identity.
    public let username: String
    /// The primary email address of the identity.
    public let primaryEmailAddress: String?
    
    public init(displayName: String, username: String, primaryEmailAddress: String?){
        self.displayName = displayName
        self.username = username
        self.primaryEmailAddress = primaryEmailAddress
    }
    
    init(_ identity: CoreSDK.Identity) {
        displayName = identity.displayName
        username = identity.username
        primaryEmailAddress = identity.primaryEmailAddress
    }
}
