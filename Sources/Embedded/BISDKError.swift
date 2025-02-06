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
    
    /// initalization not complete
    case initializationIncomplete
    
    /// setUpDirectory errors
    case outOfMemory
    case insufficientWritePermission(String)
    case insufficientReadPermission(String)
    case unknownWritePermission(String)
    case unknownReadPermission(String)
    
    static func from(_ error: BridgeError) -> Self {
        if case let .decodeError(string) = error {
            if string.lowercased().contains("credentialnotfound"){
                return .passkeyNotFound
            }
        }
        return BISDKError.description("\(error)")
    }
    
    static func from(_ error: CoreError) -> Self {
        switch error {
        case .description(let message):
            return BISDKError.description(message)
        case .outOfMemory:
            return BISDKError.outOfMemory
        case .insufficientWritePermission(let path):
            return BISDKError.insufficientWritePermission(path)
        case .insufficientReadPermission(let path):
            return BISDKError.insufficientReadPermission(path)
        case .unknownWritePermission(let path):
            return BISDKError.unknownWritePermission(path)
        case .unknownReadPermission(let path):
            return BISDKError.unknownReadPermission(path)
        @unknown default:
            return BISDKError.description("\(error)")
        }
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
        case .initializationIncomplete:
            return "Initalization failed. Tip: Embedded.initialize must be called before accessing Embedded.shared"
        case .outOfMemory:
            return "Insufficient disk space to complete operation."
        case .insufficientWritePermission(let path):
            return "Insufficient write permissions to create directory at path \(path)."
        case .insufficientReadPermission(let path):
            return "Insufficient read permissions to access directory at path \(path)."
        case .unknownWritePermission(let path):
            return "An unknown write premissions error occurred while attempting to create directory at path \(path)."
        case .unknownReadPermission(let path):
            return "An unknown read premissions error occurred while attempting to access directory at path \(path)."
        }
    }
}
