import CoreSDK
import Foundation

/// A User Credential. Think of this as a wrapper around an X.509 Certificate.
public struct Credential: Equatable {
    /// The Globally unique ID of this Credential.
    public let id: CredentialID
    
    /// The time when this credential was created locally. This could be different from "created" which is the time when this credential was created on the server.
    public let localCreated: Date
    
    /// The last time when this credential was updated locally. This could be different from "updated" which is the last time when this credential was updated on the server.
    public let localUpdated: Date
    
    /// The base url for all binding & auth requests
    public let apiBaseURL: URL
    
    /// The Identity's Tenant.
    public let tenantID: TenantID
    
    /// The Identity's Realm.
    public let realmID: RealmID
    
    /// The Identity that owns this Credential.
    public let identityID: IdentityID
    
    /// Associated key handle.
    public let keyHandle: KeyHandle
    
    /// The current state of this credential
    public let state: CredentialState
    
    /// The time this credential was created.
    public let created: Date
    
    /// The last time this credential was updated.
    public let updated: Date
    
    /// Realm information associated with this credential.
    public let realm: Realm
    
    /// Identity information associated with this credential.
    public let identity: Identity
    
    /// Theme information associated with this credential
    public let theme: Theme
    
    public init(
        id: CredentialID,
        localCreated: Date,
        localUpdated: Date,
        apiBaseURL: URL,
        tenantID: TenantID,
        realmID: RealmID,
        identityID: IdentityID,
        keyHandle: KeyHandle,
        state: CredentialState,
        created: Date,
        updated: Date,
        realm: Realm,
        identity: Identity,
        theme: Theme
    ){
        self.id = id
        self.localCreated = localCreated
        self.localUpdated = localUpdated
        self.apiBaseURL = apiBaseURL
        self.tenantID = tenantID
        self.realmID = realmID
        self.identityID = identityID
        self.keyHandle = keyHandle
        self.state = state
        self.created = created
        self.updated = updated
        self.realm = realm
        self.identity = identity
        self.theme = theme
    }
    
    init(_ credential: CoreSDK.AuthNCredential) {
        id = CredentialID(credential.id.value)
        localCreated = credential.localCreated
        localUpdated = credential.localUpdated
        apiBaseURL = credential.apiBaseURL
        tenantID = TenantID(credential.tenantID.value)
        realmID = RealmID(credential.realmID.value)
        identityID = IdentityID(credential.identityID.value)
        keyHandle = KeyHandle(credential.keyHandle.value)
        state = CredentialState(credential.state)
        created = credential.created
        updated = credential.updated
        realm = Realm(credential.realm)
        identity = Identity(credential.identity)
        theme = Theme(credential.theme)
    }
}

/// The Globally unique ID of a Credential.
public struct CredentialID: Equatable {
    /// string value for the `CredentialID`
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
}

/// The Identity that owns a Credential.
public struct IdentityID: Equatable {
    /// string value for the `IdentityID`
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
}

/// An Associated key handle.
public struct KeyHandle: Equatable {
    /// string value for the `KeyHandle`
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
}

/// The Identity's Realm.
public struct RealmID: Equatable {
    /// string value for the `RealmID`
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
}

/// The Identity's Tenant.
public struct TenantID: Equatable {
    /// string value for the `TenantID`
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
}

/// State of a given `Credential`.
@frozen
public enum CredentialState: String, CaseIterable, Equatable {
    /// Credential is active
    case active
    /// Credential is revoked
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
