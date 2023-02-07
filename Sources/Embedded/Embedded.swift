import CoreSDK
import Foundation
import os

/// Use the `Embedded.shared` singleton to access all embedded sdk functionality.
public class Embedded {
    /// Initialize the `Embedded.shared` singleton before using it. This must be called first.
    /// - Parameters:
    ///   - allowedDomains: An optional array of whitelisted domains for network operations. This will default to Beyond Identity’s allowed domains when not provided or is empty.
    ///   - biometricAskPrompt: A prompt the user will see when asked for biometrics.
    ///   - logger: Optional function to log output.
    public static func initialize(
        allowedDomains: [String]? = nil,
        biometricAskPrompt: String,
        logger: ((OSLogType, String) -> Void)? = nil,
        callback: @escaping(Result<Void, BISDKError>) -> Void
    ){
        guard let allowedDomains = allowedDomains.isNilOrEmpty
                ? ["beyondidentity.com"]
                : allowedDomains else {
            callback(.failure(BISDKError.description("Error with allowedDomains: \(String(describing: allowedDomains))")))
            return
        }
        
        CoreEmbedded._initialize(
            allowedDomains: allowedDomains,
            biometricAskPrompt: biometricAskPrompt,
            logger: logger,
            callback: callback
        )
    }
    
    /// Use this shared property to access functionality.
    /// - Note: `Embedded.initialize` must be called first.
    public static let shared = CoreEmbedded._shared
}

/// Internal implementation of all embedded sdk which should be accessed via `Embedded.shared`
public class CoreEmbedded {
    private struct Config {
        let biometricAskPrompt: String
        let logger: ((OSLogType, String) -> Void)?
    }
    
    private let INIT_ERROR = "Error - you must call Embedded.initialize before accessing Embedded.shared"
    
    private static var config: Config?
    
    private static var core: Core?
    
    private static var hasInitalizedCore = false
    
    public static let _shared: CoreEmbedded = CoreEmbedded()
    
    public static func _initialize(
        allowedDomains: [String],
        biometricAskPrompt: String,
        logger: ((OSLogType, String) -> Void)? = nil,
        callback: @escaping(Result<Void, BISDKError>) -> Void
    ){
        let config = Config(
            biometricAskPrompt: biometricAskPrompt,
            logger: logger
        )
        guard !hasInitalizedCore else { return }
        setUpCore(with: config)
        setUpDirectory(
            allowedDomains: allowedDomains.joined(separator: ","),
            callback: callback
        )
        hasInitalizedCore = true
    }
    
    private static func setUpCore(with config: Config) {
        let appInstanceId = UserDefaults.get(forKey: .appInstanceId)
        ?? UserDefaults.setString(UUID().uuidString, forKey: .appInstanceId)
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "not specified"
        
        CoreEmbedded.config = config
        
        CoreEmbedded.core = Core.live(
            // This is the version of the native platform authenticator. Since this SDK has nothing to do
            // with the native platform authenticator, we set this to a dummy value.
            appVersion: "0.0.0",
            appInstanceId: appInstanceId,
            authenticationPrompt: { _, _ in },
            deviceGatewayUrl: Configuration.deviceGateway,
            isProduction: true,
            askPrompt: config.biometricAskPrompt,
            biSdkInfo: CoreSDKInfo.init(
                sdkVersion: Configuration.sdkVersion,
                appVersion: appVersion),
            logger: config.logger,
            clientEnvironmentRequest: { ClientEnvironment() },
            selectCredentialRequest: { _, _ in },
            keyProvenanceRequest: nil,
            credentialStateChangedRequest: { }
        )
    }
    
    private static func setUpDirectory(
        allowedDomains: String,
        callback: @escaping(Result<Void, BISDKError>) -> Void
    ) {
        CoreEmbedded.core?.setUpDirectory(
            allowedDomains: allowedDomains,
            catalogFolderName: Configuration.catalogFolderName
        ) { result in
            switch result {
            case .success:
                callback(.success(()))
            case let .failure(error):
                callback(.failure(.description(error.localizedDescription)))
            }
        }
    }
}

// MARK: Functions

extension CoreEmbedded {
    /// Authenticate a user.
    /// - Parameters:
    ///   - url: URL used to authenticate
    ///   - id: `Passkey.Id` with which to authenticate.
    ///   - callback: returns a `AuthenticateResponse`.
    public func authenticate(
        url: URL,
        id: Passkey.Id,
        callback: @escaping(Result<AuthenticateResponse, BISDKError>) -> Void
    ) {
        guard isAuthenticateUrl(url) else { return callback(.failure(.invalidUrlType)) }
        
        guard let core = CoreEmbedded.core else {
            fatalError(INIT_ERROR)
        }
        
        core.authenticate(
            url,
            with: CoreSDK.Id(id.value),
            trusted: .embedded,
            flowType: .embedded
        ) { result in
            switch result {
            case let .success(response):
                callback(.success(AuthenticateResponse(response)))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }
    
    /// Bind a `Passkey` to a device.
    /// - Parameters:
    ///   - url: URL used to bind a passkey to a device
    ///   - callback: Returns the bound `Passkey` and  optional redirect URL set by the developer
    public func bindPasskey(
        url: URL,
        callback: @escaping(Result<BindPasskeyResponse, BISDKError>) -> Void
    ) {
        guard let core = CoreEmbedded.core else {
            fatalError(INIT_ERROR)
        }
        
        guard isBindPasskeyUrl(url) else { return callback(.failure(.invalidUrlType)) }
        
        core.bindCredential(
            url,
            trusted: .embedded,
            flowType: .embedded
        ) { result in
            switch result {
            case let .success(response):
                callback(.success(BindPasskeyResponse(response)))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }
    
    /// Delete a `Passkey` by its ID.
    /// - Warning: deleting a `Passkey` is destructive and will remove everything from the device. If no other device contains the passkey then the user will need to complete a recovery in order to log in again on this device.
    /// - Parameters:
    ///   - id: the unique identifier of the `Passkey`.
    ///   - callback: returns unit `()` on successful deletion
    public func deletePasskey(
        for id: Passkey.Id,
        callback: @escaping (Result<(), BISDKError>) -> Void
    ) {
        guard let core = CoreEmbedded.core else {
            fatalError(INIT_ERROR)
        }
        core.deleteAuthNCredential(CoreSDK.Id(id.value)) { result in
            switch result {
            case .success:
                callback(.success(()))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }
    
    /// Get all current passkeys on the device.
    /// - Parameter callback: returns all registered passkeys
    public func getPasskeys(callback: @escaping (Result<[Passkey], BISDKError>) -> Void) {
        guard let core = CoreEmbedded.core else {
            fatalError(INIT_ERROR)
        }
        core.getAllAuthNCredentials { result in
            switch result {
            case let .success(passkey):
                callback(.success(passkey.map(Passkey.init)))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }
    
    /// Returns whether a URL is a valid Authenticate URL or not.
    /// - Parameter url: URL in question
    public func isAuthenticateUrl(_ url: URL) -> Bool {
        guard let core = CoreEmbedded.core else {
            fatalError(INIT_ERROR)
        }
        
        let result = core.getUrlType(url)
        
        guard result == .success(.authenticate) else {
            return false
        }
        return true
    }
    
    /// Returns whether a URL is a valid Bind Passkey URL or not.
    /// - Parameter url: URL in question
    public func isBindPasskeyUrl(_ url: URL) -> Bool {
        guard let core = CoreEmbedded.core else {
            fatalError(INIT_ERROR)
        }
        
        let result = core.getUrlType(url)
        
        guard result == .success(.bind) else {
            return false
        }
        return true
    }
}

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
