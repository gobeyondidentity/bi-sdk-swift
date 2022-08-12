import Foundation

public enum Localized: String, CaseIterable {
    // Common
    case noCredentialFound

    // Embedded SDK
    case embeddedButton
    case beyondIdentityTitle
    case beyondIdentityText
    case embeddedSdkTitle
    case embeddedSdkText

    // View Embedded SDK
    case manageCredentialsButton
    case authenticateButton
    case urlVerificationButton
    case developerDocsButton
    case supportButton
    case viewEmbeddedSdkTitle
    case getStartedTitle
    
    case bindTitle
    case bindDescription
    case bindURLPlaceholder
    
    case exampleBindTitle
    case exampleBindText
    case examplePlaceholder
    
    case exampleRecoverTitle
    case exampleRecoverText
    case exampleRecoverPlaceholder

    // SDK Functionality
    case sdkFunctionalityTitle
    case sdkFunctionalityText

    // Questions or Issues?
    case supportTitle
    case supportText

    // Manage Credentials
    case credentialTitle
    case viewCredentialTitle
    case credentialText
    case deleteTitle
    case deleteText
    case deletePlaceholder

    // Authenticate
    case authenticateTitle
    case authenticateDetail
    case authenticateCustomTitle
    case authenticateCustomText
    case authenticateURLPlaceholder
    
    case authBeyondIdentity
    case authBeyondIdentityText
    
    case authOkta
    case authOktaText
    
    case authAuth0
    case authAuth0Text
    
    // Select Credential
    case selectCredentialTitle
    
    // URL Validation
    case isAuthenticateTitle
    case isAuthenticateText
    case isBindTitle
    case isBindText
    case validateButton

    // Developer Docs
    case developerDocsUrl

    // Support Page
    case supportPageUrl

    public var string: String {
        NSLocalizedString(self.rawValue, tableName: nil, bundle: .main, value: "not found", comment: "")
    }
}


