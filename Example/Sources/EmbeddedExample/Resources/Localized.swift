import Foundation

public enum Localized: String, CaseIterable {
    // Common
    case noCredentialFound
    case missingCredential

    // Embedded SDK
    case embeddedButton
    case embeddedUIButton
    case beyondIdentityTitle
    case beyondIdentityText
    case embeddedSdkTitle
    case embeddedSdkText
    case embeddedUiTitle
    case embeddedUiText

    // View Embedded SDK
    case manageCredentialsButton
    case authenticateButton
    case urlVerificationButton
    case developerDocsButton
    case supportButton
    case viewEmbeddedSdkTitle
    case viewEmbeddedUISdkTitle
    case getStartedTitle
    
    case bindTitle
    case bindDescription
    case bindURLPlaceholder

    // SDK Functionality
    case sdkFunctionalityTitle
    case sdkFunctionalityText

    // Questions or Issues?
    case supportTitle
    case supportText

    // Manage Credentials
    case getCredentialsButton
    case credentialTitle
    case viewCredentialTitle
    case credentialText
    case deleteTitle
    case deleteText
    case deletePlaceholder

    // Authenticate
    case authenticateTitle
    case authenticateText
    case authenticateURLPlaceholder
    case authOkta
    case authOktaText
    
    // URL Validation
    case isAuthenticateTitle
    case isAuthenticateText
    case isBindTitle
    case isBindText
    case validateButton

    // Developer Docs
    case DeveloperDocsUrl

    // Support Page
    case supportPageUrl

    public var string: String {
        NSLocalizedString(self.rawValue, tableName: nil, bundle: .main, value: "not found", comment: "")
    }
}


