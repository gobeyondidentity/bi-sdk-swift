import CoreSDK
import DeviceInfoSDK
import Foundation
import os

/// Use the `Embedded.shared` singleton to access all embedded sdk functionality
public class Embedded {
    private let core: Core

    /// Use this shared property to access functionality
    public static let shared: Embedded = Embedded(logger: logger(type:message:))

    init(_ core: Core? = nil, logger: ((OSLogType, String) -> Void)? = nil) {
        if let core = core {
            self.core = core
        } else {
            let appInstanceId = UserDefaults.get(forKey: .appInstanceId)
                ?? UserDefaults.setString(UUID().uuidString, forKey: .appInstanceId)

            self.core = Core.live(
                // This is the version of the native platform authenticator. Since this SDK has nothing to do
                // with the native platform authenticator, we set this to a dummy value.
                appVersion: "0.0.0",
                appInstanceId: appInstanceId,
                authenticationPrompt: { _, _ in },
                deviceGatewayUrl: Configuration.deviceGateway,
                isProduction: true,
                biSdkInfo: .init(
                    sdkVersion: Configuration.sdkVersion,
                    appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "not specified",
                    clientId: "<TODO>: Pass this in through initializer"),
                with: logger ?? Embedded.logger
            )

        }

        setUpDirectory()
    }

    static func logger(type: OSLogType, message: String) {
        print(message)
    }

    private func setUpDirectory() {
        core.setUpDirectory(
            catalogFolderName: Configuration.catalogFolderName
        ) { result in
            switch result {
            case .success: break
            case let .failure(error):
                fatalError(error.localizedDescription)
            }
        }
    }
}

// MARK: Registration

extension Embedded {    
    /**
     Use this function in the `AppDelegate` or `SceneDelegate` to intercept a user redirect during the registration or recovery flow to continue that flow. This may be triggered after a tap on a universal link from an email.
     
     - Parameters:
         - url: intercepted url during a redirect. This url must contain a host and "register" in the path. For example: `acme://host/register`
         - callback: Returns a registered `Credential`
     */
    public func registerCredential(
        _ url: URL,
        callback: @escaping (Result<Credential, BISDKError>) -> Void
    ) {
        core.register(
            from: url.absoluteString,
            trusted: .embedded
        ) { result in
            switch result {
            case let .success(response):
                guard case let .registration(registrationResponse) = response.urlResponse else {
                    return callback(
                        .failure(.description("Expected Registration, got \(response.urlResponse.value)"))
                    )
                }
                callback(.success(Credential(registrationResponse.profile)))

            case let .failure(error):
                return callback(.failure(.from(error)))

            }
        }
    }
}

// MARK: Authentication

extension Embedded {
    /**
     Used for OIDC confidential clients.
     
     Authorize a user from a confidential client and receive an `AuthorizationCode` to be used by your backend for a token exchange.
     
     This assumes the existing of a secure backend that can safely store the client secret
     and can exchange the authorization code for an access and id token.
     
     - Parameters:
         - clientID: The client ID generated during the OIDC configuration.
         - pkceChallenge: Optional but recommended to prevent authorization code injection. Use `createPKCE` to generate a `PKCE.CodeChallenge`.
         - redirectURI: URI where the user will be redirected after the authorization has completed. The redirect URI must be one of the URIs passed in the OIDC configuration.
         - scope: string list of OIDC scopes used during authentication to authorize access to a user's specific details. Only "openid" is currently supported.
         - callback: returns an AuthorizationCode to exchange for access and id token.
     */
    public func authorize(
        clientID: String,
        pkceChallenge: PKCE.CodeChallenge?,
        redirectURI: String,
        scope: String,
        callback: @escaping(Result<AuthorizationCode, BISDKError>) -> Void
    ) {
        guard let authURL = Endpoint.url(for: .authorizeEndpoint) else {
            return callback(.failure(.description("Error creating authorize URL")))
        }

        core.embeddedConfidentialOIDC(
            authURL: authURL,
            clientId: clientID,
            redirectURI: redirectURI,
            scope: scope,
            PKCECodeChallenge: pkceChallenge.map({ CoreSDK.PKCE.CodeChallenge($0) })
        ) { result in
            switch result {
            case let .success(code):
                callback(.success(AuthorizationCode(value: code.value)))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }

    /**
     Used for OIDC public clients.
     
     Authorize a user from a public client and receive a `TokenResponse`. PKCE is handled internally to mitigate against an authorization code interception attack.
     
     This assumes there is no backend and the client secret can't be safely stored.
     
     The app will get the access and id token.
     
     - Parameters:
         - clientID: The client ID generated during the OIDC configuration.
         - redirectURI: URI where the user will be redirected after the authorization has completed. The redirect URI must be one of the URIs passed in the OIDC configuration.
         - callback: returns a `TokenResponse` that contains the access and id token.
     */
    public func authenticate(
        clientID: String,
        redirectURI: String,
        callback: @escaping(Result<TokenResponse, BISDKError>) -> Void
    ) {
        guard let authURL = Endpoint.url(for: .authorizeEndpoint) else {
            return callback(.failure(.description("Error creating authorize URL")))
        }

        guard let tokenURL = Endpoint.url(for: .tokenEndpoint) else {
            return callback(.failure(.description("Error creating token URL")))
        }

        core.embeddedPublicOIDC(
            authURL: authURL,
            tokenURL: tokenURL,
            clientId: clientID,
            redirectURI: redirectURI
        ) { result in
            switch result {
            case let .success(response):
                callback(.success(TokenResponse(response)))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }

    /**
     Create a Proof Key for Code Exchange (PKCE, pronounced "pixy")
     
     Used by public clients to [mitigate authorization code interception attack.](https://datatracker.ietf.org/doc/html/rfc7636)
     
     - Parameters:
         - callback: Returns a newly generated PKCE response with a codeVerifier and codeChallenge.
     */
    public func createPKCE(callback: @escaping (Result<PKCE, BISDKError>) -> Void) {
        core.createPKCE { coreResult in
            switch coreResult {
            case let .success(pkce):
                print(Configuration.catalogFolderName)

                callback(.success(PKCE(pkce)))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }
}

// MARK: Credential Management

extension Embedded {
    /**
     Get all current credentials.
     
     Only one credential per device is currently supported.
     
     - Parameters:
         - callback: returns all registered credentials
     */
    public func getCredentials(callback: @escaping (Result<[Credential], BISDKError>) -> Void) {
        core.getProfiles { result in
            switch result {
            case let .success(profiles):
                callback(.success(profiles.map(Credential.init)))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }

    /**
     Delete a `Credential` by handle.
     - Warning: deleting a `Credential` is destructive and will remove everything from the device. If no other device contains the credential then the user will need to complete a recovery in order to log in again on this device.
     
     - Parameters:
         - handle: `Credential.Handle` uniquely  identifying a `Credential`.
         - callback: returns the deleted `Credential.Handle`.
     */
    public func deleteCredential(
        for handle: Credential.Handle,
        callback: @escaping (Result<Credential.Handle, BISDKError>) -> Void
    ) {
        core.deleteProfile(handle.value) { result in
            switch result {
            case .success:
                callback(.success(handle))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }
}

// MARK: Adding a New Device

extension Embedded {
    /**
     Export a list of credentials. The user must be in an authenticated state to export any credentials.
          
     Use this function to export credentials from one device to another.
     
     Only one credential per device is currently supported.
     
     - Parameters:
         - handles: list of `Credential` handles to be exported.
         - callback: returns an `ExportStatus` with a random 9 digit token that the user wants to export. Pass this token to `importCredentials`.
     */
    public func exportCredentials(handles: [Credential.Handle], callback: @escaping(Result<ExportStatus, BISDKError>) -> Void) {
        core.copy(withExportProgress: { status in
            switch status {
            case let .started(token):
                let credential = CredentialToken(value: token)
                callback(.success(.started(credential, generateQRCode(from: credential))))
            case let .token(token):
                let credential = CredentialToken(value: token)
                callback(.success(.tokenUpdated(credential, generateQRCode(from: credential))))
            case .received:
                callback(.success(.done))
            }
        })
        .export(handles.map({ $0.value })) { result in
            switch result {
            case .success: break
            case let .failure(error):
                let message = error.localizedDescription.lowercased()
                if message.contains("most likely user canceled") || message.contains("aborted") {
                    return callback(.success(.aborted))
                }
                callback(.failure(.from(error)))
            }
        }
    }

    /**
     Cancel an export in progress.
     
     This is called implicitly if an export succeeds or fails. Alternatively, this needs to be called if a user no longer needs to export a `Credential`.
          
     - Parameters:
         - callback: returns unit `()` on success
     */
    public func cancelExport(callback: @escaping(Result<(), BISDKError>) -> Void) {
        core.cancel { result in
            switch result {
            case .success:
                callback(.success(()))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }

    /**
     Import a `Credential`.
     
     Use this function to import a `Credential` from one device to another.
     
     Note: If a Credential already exists on a device then importing won't work. The previous Credential will still be on the device and the new imported Credential will be ignored.
          
     - Parameters:
         - token: the 9 digit code that the user entered. This may represent one or more credentials, but only one credential per device is currently supported.
         - callback: returns a list of registered credentials.
     */
    public func importCredentials(token: CredentialToken, callback: @escaping(Result<[Credential], BISDKError>) -> Void) {
        core.import(token.value, overwrite: true) { result in
            switch result {
            case let .success(profiles):
                callback(.success(profiles.map(Credential.init)))
            case let .failure(error):
                callback(.failure(.from(error)))
            }
        }
    }
}

extension URLResponseClass {
    var value: String {
        switch self {
        case .registration:
            return "Registration"
        case .selfIssue:
            return "SelfIssue"
        @unknown default:
            return "Unknown"
        }
    }
}
