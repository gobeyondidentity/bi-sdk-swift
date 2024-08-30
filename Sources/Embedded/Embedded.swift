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
                ? ["beyondidentity.com", "byndid.com"]
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
    
    /// Initialize the `Embedded.shared` singleton before using it. This must be called first.
    /// - Parameters:
    ///   - allowedDomains: An optional array of whitelisted domains for network operations. This will default to Beyond Identity’s allowed domains when not provided or is empty.
    ///   - biometricAskPrompt: A prompt the user will see when asked for biometrics.
    ///   - logger: Optional function to log output.
    public static func initialize(
        allowedDomains: [String]? = nil,
        biometricAskPrompt: String,
        logger: ((OSLogType, String) -> Void)? = nil
    ) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                self.initialize(
                    allowedDomains: allowedDomains,
                    biometricAskPrompt: biometricAskPrompt,
                    logger: logger,
                    callback: continuation.resume
                )
            }
        }
    }
    
    /// Use this shared property to access functionality.
    /// - Note: `Embedded.initialize` must be called first.
    public static let shared = CoreEmbedded._shared
}

/// Internal implementation of all embedded sdk which should be accessed via `Embedded.shared`
public class CoreEmbedded {
    private struct Config {
        let allowedDomains: [String]
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
            allowedDomains: allowedDomains,
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
            logger: config.logger
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
    ///   - url: The authentication URL of the current transaction.
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
            url: url,
            trusted: .embedded,
            flowType: .embedded,
            credentialDescriptor: .credentialId(credential_id: id.value)
        ) { result in
            switch result {
            case let .success(response):
                switch response {
                case let .allow(authenticateUrlResponse):
                    callback(.success(AuthenticateResponse(authenticateUrlResponse)))
                default:
                    callback(.failure(.description("BiAuthenticateUrlResponse was not sent")))
                }
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }
    
    /// Authenticate a user.
    /// - Parameters:
    ///   - url: The authentication URL of the current transaction.
    ///   - id: `Passkey.Id` with which to authenticate.
    /// - Returns: `AuthenticateResponse`
    public func authenticate(
        url: URL,
        id: Passkey.Id
    ) async throws -> AuthenticateResponse {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                self.authenticate(url: url, id: id, callback: continuation.resume)
            }
        }
    }
    
    /// Initiates authentication using an OTP, which will be sent to the
    /// provided email address.
    /// - Parameter url: The authentication URL of the current transaction.
    /// - Parameter email: The email address where the OTP will be sent.
    /// - Parameter callback: Returns an `OtpChallengeResponse` containing a URL with the state of the authentication.
    public func authenticateOtp(
        url: URL,
        email: String,
        callback: @escaping(Result<OtpChallengeResponse, BISDKError>) -> Void
    ) {
        guard isAuthenticateUrl(url) else { return callback(.failure(.invalidUrlType)) }
        
        guard let core = CoreEmbedded.core else {
            fatalError(INIT_ERROR)
        }
        
        core.authenticate(
            url: url,
            trusted: .embedded,
            flowType: .embedded,
            credentialDescriptor: .beginEmailOtp(email: email)
        ) { result in
            switch result {
            case let .success(response):
                switch response {
                case let .continue(continueResponse):
                    callback(.success(OtpChallengeResponse(continueResponse)))
                default:
                    callback(.failure(.description("BiContinueResponse was not sent")))
                }
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }
    
    /// Initiates authentication using an OTP, which will be sent to the
    /// provided email address.
    /// - Parameter url: The authentication URL of the current transaction.
    /// - Parameter email: The email address where the OTP will be sent.
    /// - Returns: Returns an `OtpChallengeResponse` containing a URL with the state of the authentication.
    public func authenticateOtp(
        url: URL,
        email: String
    ) async throws -> OtpChallengeResponse {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                self.authenticateOtp(url: url, email: email, callback: continuation.resume)
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
            flowType: .embedded,
            credentialDescriptor: nil
        ) { result in
            switch result {
            case let .success(response):
                callback(.success(BindPasskeyResponse(response)))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }
    
    /// Bind a `Passkey` to a device.
    /// - Parameters:
    ///   - url: URL used to bind a passkey to a device
    /// - Returns: the bound `Passkey` and  optional redirect URL set by the developer wrapped inside `BindPasskeyResponse`
    public func bindPasskey(url: URL) async throws -> BindPasskeyResponse {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                self.bindPasskey(url: url, callback: continuation.resume)
            }
        }
    }
    
    /// Delete a `Passkey` by its ID.
    /// - Note: It is possible to delete a passkey that does not exist.
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
    
    /// Delete a `Passkey` by its ID.
    /// - Warning: deleting a `Passkey` is destructive and will remove everything from the device. If no other device contains the passkey then the user will need to complete a recovery in order to log in again on this device.
    /// - Parameters:
    ///   - id: the unique identifier of the `Passkey`.
    public func deletePasskey(for id: Passkey.Id) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                self.deletePasskey(for: id, callback: continuation.resume)
            }
        }
    }
    
    /// Get the Authentication Context for the current transaction.
    ///
    /// The Authentication Context contains the Authenticator Config,
    /// Authentication Method Configuration, request origin, and the
    /// authenticating application.
    /// - Note: This is used to retrieve authentication parameters for an ongoing transaction such as `authenticateOtp` and `redeemOtp`.
    ///
    /// - Parameter url: The authentication URL of the current transaction.
    /// - Parameter callback: returns an `AuthenticationContext`.
    public func getAuthenticationContext(
        url: URL,
        callback: @escaping(Result<AuthenticationContext, BISDKError>) -> Void
    ) {
        guard let core = CoreEmbedded.core else {
            fatalError(INIT_ERROR)
        }
        
        guard let config = CoreEmbedded.config else {
            fatalError(INIT_ERROR)
        }
        
        core.getAuthenticationContext(
            url,
            config.allowedDomains.joined(separator: ",")
        ) { result in
            switch result {
            case let .success(response):
                callback(.success(AuthenticationContext(response)))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }
    
    /// Get the Authentication Context for the current transaction.
    ///
    /// The Authentication Context contains the Authenticator Config,
    /// Authentication Method Configuration, request origin, and the
    /// authenticating application.
    /// - Note: This is used to retrieve authentication parameters for an ongoing transaction such as `authenticateOtp` and `redeemOtp`.
    ///
    /// - Parameter url: The authentication URL of the current transaction.
    /// - Returns: `AuthenticationContext`
    public func getAuthenticationContext(
        url: URL
    ) async throws -> AuthenticationContext {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                self.getAuthenticationContext(url: url, callback: continuation.resume)
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
    
    /// Get all current passkeys on the device.
    /// - Returns: all registered passkeys
    public func getPasskeys() async throws -> [Passkey] {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                self.getPasskeys(callback: continuation.resume)
            }
        }
    }
    
    /// Returns whether a URL is a valid Authenticate URL or not.
    /// - Parameter url: URL in question
    /// - Returns: Bool
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
    /// - Returns: Bool
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
    
    /// Redeems an OTP for a grant code.
    ///
    /// - Parameter url: The authentication URL of the current transaction.
    /// - Parameter otp: The OTP to redeem.
    /// - Parameter callback: Returns `RedeemOtpResponse` that resolves to an `AuthenticateResponse` on success or an `OtpChallengeResponse` on failure to authenticate with the provided OTP code.
    /// - Note: Use the url provided in `OtpChallengeResponse` for retry.
    public func redeemOtp(
        url: URL,
        otp: String,
        callback: @escaping(Result<RedeemOtpResponse, BISDKError>) -> Void
    ) {
        guard let core = CoreEmbedded.core else {
            fatalError(INIT_ERROR)
        }
        
        core.authenticate(
            url: url,
            trusted: .embedded,
            flowType: .embedded,
            credentialDescriptor: .redeemOtp(otp: otp)
        ) { result in
            switch result {
            case let .success(response):
                switch response {
                case let .allow(authenticateUrlResponse):
                    callback(.success(.success(AuthenticateResponse(authenticateUrlResponse))))
                case let .continue(continueResponse):
                    callback(.success(.failedOtp(OtpChallengeResponse(continueResponse))))
                }
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }
    
    /// Redeems an OTP for a grant code.
    /// - Parameter url: The authentication URL of the current transaction.
    /// - Parameter otp: The OTP to redeem.
    /// - Returns: `RedeemOtpResponse` that resolves to an `AuthenticateResponse` on success or an `OtpChallengeResponse` on failure to authenticate with the provided OTP code.
    /// - Note: Use the url provided in `OtpChallengeResponse` for retry.
    public func redeemOtp(
        url: URL,
        otp: String
    ) async throws -> RedeemOtpResponse {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                self.redeemOtp(url: url, otp: otp, callback: continuation.resume)
            }
        }
    }
}

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
