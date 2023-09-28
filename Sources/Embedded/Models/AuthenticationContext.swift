import CoreSDK
import Foundation

/// Information associated with the current authentication.
///
/// Note that the `authUrl` field may differ from the URL passed into
/// `getAuthenticationContext`. In this event, the new `authUrl` must be
/// passed into `authenticate` or `authenticateOtp`, rather than the
/// original URL.
public struct AuthenticationContext: Equatable, Hashable {
    /// A URL containing the state of the current authentication transaction.
    public let authUrl: URL
    /// The authenticating application information
    public let application: Application
    /// The authenticating request origin information
    public let origin: Origin
    
    public init(
        authUrl: URL,
        application: Application,
        origin: Origin
    ){
        self.authUrl = authUrl
        self.application = application
        self.origin = origin
    }
    
    init(_ response: CoreSDK.AuthenticationContext) {
        self.authUrl = response.authURL
        
        self.application = Application(
            id: Application.Id(response.application.id),
            displayName:response.application.displayName
        )
        self.origin = Origin(
            sourceIp: response.origin.sourceIp,
            userAgent: response.origin.userAgent,
            geolocation: response.origin.geolocation,
            referer: response.origin.referer
        )
    }
}

extension AuthenticationContext {
    public struct Application: Codable, Equatable, Hashable {
        /// The unique identifier of the Application.
        public let id: Id
        /// The displayName of the Application.
        public let displayName: String?
        
        public init(
            id: Application.Id,
            displayName: String?
        ){
            self.id = id
            self.displayName = displayName
        }
    }
}

extension AuthenticationContext.Application {
    /// The unique identifier of the Application.
    public struct Id: Equatable, Hashable, Codable {
        public let value: String
        
        public init(_ value: String) {
            self.value = value
        }
    }
}

extension AuthenticationContext {
    public struct Origin: Codable, Equatable, Hashable {
        public let sourceIp: String?
        public let userAgent: String?
        public let geolocation: String?
        public let referer: String?
        
        public init(
            sourceIp: String?,
            userAgent: String?,
            geolocation: String?,
            referer: String?
        ){
            self.sourceIp = sourceIp
            self.userAgent = userAgent
            self.geolocation = geolocation
            self.referer = referer
        }
    }
}
