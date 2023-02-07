import CoreSDK
import Foundation

/// Realm information associated with a `Passkey`.
/// A Realm is a unique administrative domain within a `Tenant`.
/// Some Tenants will only need the use of a single Realm, in this case a Realm and a Tenant may seem synonymous.
/// Each Realm contains a unique set of Directory, Policy, Event, Application, and Branding objects.
public struct Realm: Equatable, Hashable {
    /// The unique identifier of the Realm.
    public let id: Id
    /// The display name of the realm.
    public let displayName: String
    
    public init(id: Realm.Id, displayName: String){
        self.id = id
        self.displayName = displayName
    }
    
    init(_ realm: CoreSDK.Realm) {
        id = Id(realm.id.value)
        displayName = realm.displayName
    }
}

extension Realm {
    /// The unique identifier of the Realm.
    public struct Id: Equatable, Hashable, Codable {
        public let value: String
        
        public init(_ value: String) {
            self.value = value
        }
    }
}
