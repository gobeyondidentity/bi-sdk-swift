import CoreSDK
import Foundation
import os

/// Use the `Embedded.shared` singleton to access all embedded sdk functionality.
public class Embedded {
    /// Initialize the `Embedded.shared` singleton before using it. This must be called first and is async.
    /// - Parameters:
    ///   - allowedDomains: Optional array of domains that we whitelist against for network operations. This will default to Beyond Identity's allowed domains.
    ///   - biometricAskPrompt: A prompt the user will see when asked for biometrics while extending a credential to another device.
    ///   - logger: Optional function to log output
    public static func initialize(
        allowedDomains: [String] = ["beyondidentity.com"],
        biometricAskPrompt: String,
        logger: ((OSLogType, String) -> Void)? = nil,
        callback: @escaping(Result<Void, BISDKError>) -> Void
    ){
        CoreEmbedded.initialize(
            allowedDomains: allowedDomains,
            biometricAskPrompt: biometricAskPrompt,
            logger: logger,
            callback: callback
        )
    }
    
    /// Use this shared property to access functionality.
    /// - Note: `Embedded.initialize` must be called first.
    public static let shared = CoreEmbedded.shared
}

public class CoreEmbedded {
    private struct Config {
        let biometricAskPrompt: String
        let logger: ((OSLogType, String) -> Void)?
    }
    
    private let INIT_ERROR = "Error - you must call Embedded.initialize before accessing Embedded.shared"
    
    private static var config: Config?
    
    private static var core: Core?
    
    public static let shared: CoreEmbedded = CoreEmbedded()
    
    public static func initialize(
        allowedDomains: [String],
        biometricAskPrompt: String,
        logger: ((OSLogType, String) -> Void)? = nil,
        callback: @escaping(Result<Void, BISDKError>) -> Void
    ){
        let config = Config(
            biometricAskPrompt: biometricAskPrompt,
            logger: logger
        )
        
        setUpCore(with: config)
        setUpDirectory(
            allowedDomains: allowedDomains.joined(separator: ","),
            callback: callback
        )
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
            keyProvenanceRequest: nil
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
    ///   - onSelectCredential: Callback used to display a list of filtered Credentials associated with the current authentication flow. To select a Credential, return the selected `CredentialID`.
    ///   - callback: returns a `AuthenticateResponse`.
    public func authenticate(
        url: URL,
        onSelectCredential: @escaping ([Credential], @escaping ((CredentialID?) -> Void)) -> Void,
        callback: @escaping(Result<AuthenticateResponse, BISDKError>) -> Void
    ) {
        guard isAuthenticateUrl(url) else { return callback(.failure(.invalidUrlType)) }
        
        guard let core = CoreEmbedded.core else {
            fatalError(INIT_ERROR)
        }
        
        guard let config = CoreEmbedded.config else {
            fatalError(INIT_ERROR)
        }
        
        core.copy(withSelectAuthNCredentials: { credentials in
            var selectResult: Result<String?, BridgeError> = .success(nil)
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.main.async {
                onSelectCredential(credentials.map(Credential.init)) { id in
                    selectResult = .success(id?.value ?? nil)
                    group.leave()
                }
            }
            group.wait()
            return selectResult
        })
        .authenticate(
            url,
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
    
    /// Bind a `Credential` to a device.
    /// - Parameters:
    ///   - url: URL used to bind a credential to a device
    ///   - callback: Returns the bound `Credential` and  optional redirect URL set by the developer
    public func bindCredential(
        url: URL,
        callback: @escaping(Result<BindCredentialResponse, BISDKError>) -> Void
    ) {
        guard let core = CoreEmbedded.core else {
            fatalError(INIT_ERROR)
        }
        
        guard isBindUrl(url) else { return callback(.failure(.invalidUrlType)) }
        
        core.bindCredential(
            url,
            trusted: .embedded,
            flowType: .embedded
        ) { result in
            switch result {
            case let .success(response):
                callback(.success(BindCredentialResponse(response)))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }
    
    /// Delete a `Credential` by its ID.
    /// - Warning: deleting a `Credential` is destructive and will remove everything from the device. If no other device contains the credential then the user will need to complete a recovery in order to log in again on this device.
    /// - Parameters:
    ///   - id: `CredentialID` the unique identifier of the `Credential`.
    ///   - callback: returns unit `()` on successful deletion
    public func deleteCredential(
        for id: CredentialID,
        callback: @escaping (Result<(), BISDKError>) -> Void
    ) {
        guard let core = CoreEmbedded.core else {
            fatalError(INIT_ERROR)
        }
        core.deleteAuthNCredential(CoreSDK.CredentialID(id.value)) { result in
            switch result {
            case .success:
                callback(.success(()))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }
    
    /// Get all current credentials on the device.
    /// - Parameter callback: returns all registered credentials
    public func getCredentials(callback: @escaping (Result<[Credential], BISDKError>) -> Void) {
        guard let core = CoreEmbedded.core else {
            fatalError(INIT_ERROR)
        }
        core.getAllAuthNCredentials { result in
            switch result {
            case let .success(credential):
                callback(.success(credential.map(Credential.init)))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }
    
    /// Determines if a URL is a valid Authenticate URL or not.
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
    
    /// Determines if a URL is a valid Bind URL or not.
    /// - Parameter url: URL in question
    public func isBindUrl(_ url: URL) -> Bool {
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
