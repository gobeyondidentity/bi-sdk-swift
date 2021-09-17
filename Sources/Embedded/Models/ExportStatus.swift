import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

/// Status of Exporting Credentials
@frozen
public enum ExportStatus {
    
    /// First time a token is received.
    case started(CredentialToken, QRCode?)
    
    /// New token received. A token will be cycled every few minutes.
    case tokenUpdated(CredentialToken, QRCode?)
    
    /// Export complete.
    case done
}
