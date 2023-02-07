import CoreSDK
import Foundation

/// Error returned from the Embedded SDK.
public enum BISDKError: Equatable, Error, Hashable {
    /// `Passkey` for this user does not exist on this device.
    case passkeyNotFound
    
    /// URL provided is invalid
    case invalidUrlType
    
    /// string description of the error.
    case description(String)
    
    static func from(_ error: BridgeError) -> Self {
        if case let .decodeError(string) = error {
            if string.lowercased().contains("credentialnotfound"){
                return .passkeyNotFound
            }
        }
        return BISDKError.description("\(error)")
    }
}

extension BISDKError: LocalizedError {
    
    /// localized error description.
    public var errorDescription: String? {
        switch self {
        case let .description(message):
            return message
        case .passkeyNotFound:
            return "Passkey for this user does not exist on this device"
        case .invalidUrlType:
            return "URL provided is invalid"
        }
    }
}
