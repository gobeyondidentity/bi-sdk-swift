import CoreSDK
import Foundation

/// Realm information associated with a credential.
public struct Realm: Equatable, Hashable {
    /// The display name of the realm.
    public let displayName: String
    
    public init(
        displayName: String
    ){
        self.displayName = displayName
    }
    
    init(_ realm: CoreSDK.Realm) {
        displayName = realm.displayName
    }
}
