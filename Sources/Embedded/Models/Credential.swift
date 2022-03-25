import CoreSDK
import Foundation

/// A User Credential. Think of this as a wrapper around an X.509 Certificate.
public struct Credential: Equatable {
    
    /// The date the `Credential` was created.
    public let created: String?
    
    /// The handle for the `Credential`. This is identical to your `tenant_id`.
    public let handle: Handle?
    
    /// The enclave key handle. This handle is used to identify a private key in the T2 enclave or keychain.
    public let keyHandle: String?
    
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
    public let rootFingerprint: String?
    
    /// The state of the given `Credential`.
    public let state: CredentialState
    
    init(_ profile: CoreSDK.Profile) {
        created = profile.created
        handle = Handle(profile.handle)
        keyHandle = profile.keyHandle
        name = profile.name
        logoURL = profile.logoURL
        loginURI = profile.loginURI
        enrollURI = profile.enrollURI
        chain = profile.chain
        rootFingerprint = profile.rootFingerprint
        state = .active
    }
    
    init(_ credential: CoreSDK.Credential) {
        var mutableState = credential.state
        
        switch credential.created {
        case let .success(date):
            created = date
        case .failure(_):
            created = nil
            mutableState = .invalid
        }
        
        switch credential.handle {
        case let .success(handle):
            self.handle = Handle(handle)
        case .failure(_):
            self.handle = nil
            mutableState = .invalid
        }
        
        switch credential.keyHandle {
        case let .success(keyHandle):
            self.keyHandle = keyHandle
        case .failure(_):
            self.keyHandle = nil
            mutableState = .invalid
        }
        
        switch credential.rootFingerprint {
        case let .success(rootFingerprint):
            self.rootFingerprint = rootFingerprint
        case .failure(_):
            self.rootFingerprint = nil
            mutableState = .invalid
        }
        
        chain = credential.chainHandles.compactMap { chainHandle in
            switch chainHandle {
            case let .success(handle):
                return handle
            case .failure(_):
                mutableState = .invalid
                return nil
            }
        }
        
        name = credential.name
        logoURL = credential.imageUrl
        loginURI = credential.loginUri
        enrollURI = credential.enrollUri
        state = CredentialState(mutableState)
    }
    
    /// The handle for the `Credential`.
    public struct Handle: Equatable {
        
        /// string value for `Credential.Handle`
        public let value: String
        
        /// initialize a `Credential.Handle` with a value
        public init(_ value: String){
            self.value = value
        }
    }
}

/// State of a given `Credential`.
@frozen
public enum CredentialState: String, Equatable {
    /// Credential is active
    case active
    /// User is suspended
    case userSuspended
    /// User has been deleted
    case userDeleted
    /// Device has been deleted
    case deviceDeleted
    /// One or more fields failed their integrity checks
    case invalid
    
    init(_ state: CoreSDK.ProfileState){
        switch state {
        case .active:
            self = .active
        case .userSuspended:
            self = .userSuspended
        case .userDeleted:
            self = .userDeleted
        case .deviceDeleted:
            self = .deviceDeleted
        case .invalid:
            self = .invalid
        }
    }
}
