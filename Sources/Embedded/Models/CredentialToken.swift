import Foundation

/// A random 9 digit token associated with a list of Credentials being imported or exported
public struct CredentialToken {
    
    /// string value for the random 9 digit token
    public let value: String

    /// initialize a `CredentialToken` from a `String`
    public init(value: String) {
        self.value = value
    }
}
