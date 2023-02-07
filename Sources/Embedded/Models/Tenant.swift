import CoreSDK
import Foundation

/// Tenant information associated with a `Passkey`.
/// A Tenant represents an organization in the Beyond Identity Cloud and serves as a root container for all other cloud components in your configuration.
public struct Tenant: Equatable, Hashable {
    /// The unique identifier of the Tenant.
    public let id: Id
    /// The display name of the Tenant
    public let displayName: String
    
    public init(id: Tenant.Id, displayName: String){
        self.id = id
        self.displayName = displayName
    }
    
    init(_ tenant: CoreSDK.Tenant) {
        id = Id(tenant.id.value)
        displayName = tenant.displayName
    }
}

extension Tenant {
    /// The unique identifier of the Tenant.
    public struct Id: Equatable, Hashable, Codable {
        public let value: String
        
        public init(_ value: String) {
            self.value = value
        }
    }
}
