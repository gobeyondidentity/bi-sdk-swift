import CoreSDK
import Foundation

/// A Universal Passkey is a public and private key pair. The private key is generated, stored, and never leaves the [Secure Enclave](https://support.apple.com/guide/security/secure-enclave-sec59b0b31ff/web).
/// The public key is sent to the Beyond Identity cloud. The private key cannot be tampered with, viewed, or removed from the device in which it is created unless the user explicitly indicates that the trusted device be removed.
/// Passkeys are cryptographically linked to devices and an Identity. A single device can store multiple passkeys for different users and a single Identity can have multiple passkeys.
public struct Passkey: Equatable, Identifiable, Hashable {
    /// The globally unique identifier of the passkey.
    public let id: Id

    /// The external (cloud) identifier of the passkey.
    public let passkeyId: PasskeyId
    
    /// The time when this passkey was created locally. This could be different from "created" which is the time when this passkey was created on the server.
    public let localCreated: Date
    
    /// The last time when this passkey was updated locally. This could be different from "updated" which is the last time when this passkey was updated on the server.
    public let localUpdated: Date
    
    /// The base url for all binding & auth requests
    public let apiBaseUrl: URL
    
    /// Associated key handle.
    public let keyHandle: KeyHandle
    
    /// The current state of this passkey
    public let state: State
    
    /// The time this passkey was created.
    public let created: Date
    
    /// The last time this passkey was updated.
    public let updated: Date
    
    /// Tenant information associated with this passkey.
    public let tenant: Tenant
    
    /// Realm information associated with this passkey.
    public let realm: Realm
    
    /// Identity information associated with this passkey.
    public let identity: Identity
    
    /// Theme information associated with this passkey
    public let theme: Theme
    
    public init(
        id: Passkey.Id,
        passkeyId: Passkey.PasskeyId,
        localCreated: Date,
        localUpdated: Date,
        apiBaseUrl: URL,
        keyHandle: KeyHandle,
        state: Passkey.State,
        created: Date,
        updated: Date,
        tenant: Tenant,
        realm: Realm,
        identity: Identity,
        theme: Theme
    ){
        self.id = id
        self.passkeyId = passkeyId
        self.localCreated = localCreated
        self.localUpdated = localUpdated
        self.apiBaseUrl = apiBaseUrl
        self.keyHandle = keyHandle
        self.state = state
        self.created = created
        self.updated = updated
        self.tenant = tenant
        self.realm = realm
        self.identity = identity
        self.theme = theme
    }
    
    init(_ passkey: CoreSDK.AuthNCredential) {
        id = Passkey.Id(passkey.id.value)
        passkeyId = Passkey.PasskeyId(passkey.passkeyId)
        localCreated = passkey.localCreated
        localUpdated = passkey.localUpdated
        apiBaseUrl = passkey.apiBaseURL
        keyHandle = KeyHandle(passkey.keyHandle.value)
        state = Passkey.State(passkey.state)
        created = passkey.created
        updated = passkey.updated
        tenant = Tenant(passkey.tenant)
        realm = Realm(passkey.realm)
        identity = Identity(passkey.identity)
        theme = Theme(passkey.theme)
    }
}

extension Passkey {
    /// The globally unique identifier of the passkey.
    public struct Id: Equatable, Hashable, Codable {
        public let value: String
        
        public init(_ value: String) {
            self.value = value
        }
    }

    /// The external (cloud) identifier of the passkey.
    public struct PasskeyId: Equatable, Hashable, Codable {
        public let value: String
        
        public init(_ value: String) {
            self.value = value
        }
    }
}

extension Passkey {
    /// State of a given `Passkey`.
    @frozen
    public enum State: String, CaseIterable, Equatable, Hashable {
        /// Passkey is active
        case active
        /// Passkey is revoked
        case revoked
        
        init(_ state: CoreSDK.AuthNCredentialState){
            switch state {
            case .active:
                self = .active
            case .revoked:
                self = .revoked
            }
        }
    }
}

/// An Associated key handle.
public struct KeyHandle: Equatable, Hashable {
    /// string value for the `KeyHandle`
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
}
