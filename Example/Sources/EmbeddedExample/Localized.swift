import Foundation

public enum Localized: String, CaseIterable {
    // Common
    case noCredentialFound
    case missingCredential

    // Embedded SDK
    case authButton
    case embeddedButton
    case embeddedUIButton
    case beyondIdentityTitle
    case beyondIdentityText
    case embeddedSdkTitle
    case embeddedSdkText
    case embeddedUiTitle
    case embeddedUiText
    case authenticatorTitle
    case authenticatorText

    // View Embedded SDK
    case manageCredentialsButton
    case extendCredentialsButton
    case authenticateButton
    case developerDocsButton
    case supportButton
    case createUserEmailField
    case createUserButton
    case viewEmbeddedSdkTitle
    case getStartedTitle
    case registerTitle
    case registerText
    case recoverTitle
    case recoverText
    case recoverNote

    // SDK Functionality
    case sdkFunctionalityTitle
    case sdkFunctionalityText

    // Questions or Issues?
    case supportTitle
    case supportText

    // Manage Credentials
    case deleteCredentialButton
    case getCredentialsButton
    case credentialTitle
    case viewCredentialTitle
    case credentialText
    case deleteTitle
    case deleteText

    // Extend Credentials
    case extendButton
    case extendCancelButton
    case registerButton
    case registerField
    case extendRegisterTitle
    case extendRegisterText
    case extendTitle
    case extendText
    case noteText
    case cancelTitle
    case cancelText
    case registerCredentialTitle
    case registerCredentialText
    case cancelExtendCredentials

    //Authenticate
    case authorizeButton
    case authenticateUnsafeButton
    case pkceButton
    case authenticateAuthButon
    case AuthenticateTitle
    case accessText
    case oidcPublicText
    case publicClientText
    case oidcConfidentialText
    case ConfidentialClientText
    case stepOneText
    case stepTwoText
    case useAuthorizeText
    case stepThreeText
    case clientSecretText
    case importantNoteText
    case authenticateUnsafeText
    case base64Error

    // Developer Docs
    case DeveloperDocsUrl

    // Support Page
    case supportPageUrl

    public var string: String {
        NSLocalizedString(self.rawValue, tableName: nil, bundle: .main, value: "not found", comment: "")
    }
}


