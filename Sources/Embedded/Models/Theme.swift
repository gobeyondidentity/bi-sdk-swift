import CoreSDK
import Foundation

/// Theme associated with a credential.
public struct Theme: Equatable, Hashable {
    /// URL resolving the logo in light mode.
    public let logoLightURL: URL
    /// URL resolving the logo in dark mode.
    public let logoDarkURL: URL
    /// URL for customer support.
    public let supportURL: URL
    
    public init(
        logoLightURL: URL,
        logoDarkURL: URL,
        supportURL: URL
    ){
        self.logoLightURL = logoLightURL
        self.logoDarkURL = logoDarkURL
        self.supportURL = supportURL
    }
    
    init(_ theme: CoreSDK.Theme) {
        logoLightURL = theme.logoLightURL
        logoDarkURL = theme.logoDarkURL
        supportURL = theme.supportURL
    }
}
