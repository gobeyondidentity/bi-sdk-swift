import CoreSDK
import Foundation

/// Status of a user's registration
public enum UserStatus: Equatable {
    
    /// The `User` is active
    case active
    
    /// The `User` is suspended
    case suspended
    
    /// The `User` has been deleted
    case deleted

    init(_ status: CoreSDK.RegistrationStatus) {
        switch status {
        case .userStatusActive:
            self = .active
        case .userStatusSuspended:
            self = .suspended
        case .userStatusDeleted:
            self = .suspended
        }
    }
}

