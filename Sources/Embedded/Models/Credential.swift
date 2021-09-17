import CoreSDK
import Foundation

/// A User Credential. Think of this as a wrapper around an X.509 Certificate.
public struct Credential: Equatable {
    
    /// The date the `Credential` was created.
    public let created: String
    
    /// The handle for the `Credential`. This is identical to your `tenant_id`.
    public let handle: Handle
    
    /// The enclave key handle. This handle is used to identify a private key in the T2 enclave or keychain.
    public let keyHandle: String
    
    /// The human-readable display name of the `Credential`.
    public let name: String
    
    /// The uri of your company or app's logo.
    public let logoURL: String
    
    /// The uri of your app's sign in screen. This is where the user would authenticate into your app.
    public let loginURI: String?
    
    /// The uri of your app's sign up screen. This is where the user would register with your service.
    public let enrollURI: String?
    
    /// The certificate chain of the `Credential` in PEM-guarded X509 format.
    public let chain: [String]
    
    /// The SHA256 hash of the root certificate as a base64 encoded string.
    public let rootFingerprint: String

    init(_ profile: CoreSDK.Profile) {
        created = profile.created
        handle = Handle(value: profile.handle)
        keyHandle = profile.keyHandle
        name = profile.name
        logoURL = profile.logoURL
        loginURI = profile.loginURI
        enrollURI = profile.enrollURI
        chain = profile.chain
        rootFingerprint = profile.rootFingerprint
    }

    /// The handle for the `Credential`.
    public struct Handle: Equatable {
        
        /// string value for `Credential.Handle`
        public let value: String
    }
}
