import CoreSDK
import Foundation

/// Tenant information associated with a credential.
public struct Tenant: Equatable, Hashable {
    /// The display name of the tenant
    public let displayName: String
    
    public init(
        displayName: String
    ){
        self.displayName = displayName
    }
    
    init(_ tenant: CoreSDK.Tenant) {
        displayName = tenant.displayName
    }
}
