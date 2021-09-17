import CoreSDK
import Foundation

/// structure containing `User` information
public struct User: Equatable {
    
    /// A randomly generated unique ID that Beyond Identity sets for the user. This is needed for updating the user.
    public let internalID: String
    
    /// A unique identifier for the user that you set and may be associated with your database. This is needed for recovery.
    public let externalID: String
    
    /// A user's email
    public let email: String
    
    /// A user's user name
    public let userName: String
    
    /// A user's display name
    public let displayName: String
    
    /// The date the user was created
    public let dateCreated: Date
    
    /// The last date the user was modified
    public let dateModified: Date
    
    /// The user's current status
    public let status: UserStatus
}

extension User {
    init(_ response: CoreSDK.CreateUserResponse) {
        internalID = response.internalID
        externalID = response.externalID
        email = response.email
        userName = response.userName
        displayName = response.displayName
        dateCreated = response.dateCreated
        dateModified = response.dateModified
        status = UserStatus(response.status)
    }
    
    init(_ response: CoreSDK.RecoverUserResponse) {
        internalID = response.internalID
        externalID = response.externalID
        email = response.email
        userName = response.userName
        displayName = response.displayName
        dateCreated = response.dateCreated
        dateModified = response.dateModified
        status = UserStatus(response.status)
    }
}
