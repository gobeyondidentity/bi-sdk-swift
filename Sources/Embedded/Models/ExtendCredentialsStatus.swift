import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

/// Status of Extending Credentials
@frozen
public enum ExtendCredentialsStatus {
    /// User aborted the extend credential operation
    case aborted
    
    /// First time a token is received.
    case started(CredentialToken, QRCode?)
    
    /// New token received. A token will be cycled every few minutes.
    case tokenUpdated(CredentialToken, QRCode?)
    
    /// Extend credential complete.
    case done
}
