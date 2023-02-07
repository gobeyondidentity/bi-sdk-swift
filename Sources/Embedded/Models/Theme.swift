import CoreSDK
import Foundation

/// Theme associated with a `Passkey`.
public struct Theme: Equatable, Hashable {
    /// URL resolving the logo in light mode.
    public let logoLightUrl: URL
    /// URL resolving the logo in dark mode.
    public let logoDarkUrl: URL
    /// URL for customer support.
    public let supportUrl: URL
    
    public init(
        logoLightUrl: URL,
        logoDarkUrl: URL,
        supportUrl: URL
    ){
        self.logoLightUrl = logoLightUrl
        self.logoDarkUrl = logoDarkUrl
        self.supportUrl = supportUrl
    }
    
    init(_ theme: CoreSDK.Theme) {
        logoLightUrl = theme.logoLightURL
        logoDarkUrl = theme.logoDarkURL
        supportUrl = theme.supportURL
    }
}
