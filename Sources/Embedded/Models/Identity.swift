import CoreSDK
import Foundation

/// Identity information associated with a `Passkey`.
/// An Identity is a unique identifier that may be used by an end-user to gain access governed by Beyond Identity.
/// An Identity is created at the Realm level.
/// An end-user may have multiple identities. A Realm can have many Identities.
public struct Identity: Equatable, Hashable {
    /// The unique identifier of the Identity.
    public let id: Id
    /// The display name of the identity.
    public let displayName: String
    /// The username of the identity.
    public let username: String
    /// The primary email address of the identity.
    public let primaryEmailAddress: String?
    
    public init(id: Identity.Id, displayName: String, username: String, primaryEmailAddress: String?){
        self.id = id
        self.displayName = displayName
        self.username = username
        self.primaryEmailAddress = primaryEmailAddress
    }
    
    init(_ identity: CoreSDK.Identity) {
        id = Id(identity.id.value)
        displayName = identity.displayName
        username = identity.username
        primaryEmailAddress = identity.primaryEmailAddress
    }
}

extension Identity {
    /// The unique identifier of the Identity.
    public struct Id: Equatable, Hashable, Codable {
        public let value: String
        
        public init(_ value: String) {
            self.value = value
        }
    }
}
