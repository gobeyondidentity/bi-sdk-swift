
import Foundation

public enum LocalizedString: String, CaseIterable {
    // Authenticator
    case signInButtonTitle
    case signUpButtonTitle
    
    // EmbeddedUI
    case alertErrorAction
    
    case alternateOptionsAddDeviceText
    case alternateOptionsAddDeviceTappableText
    case alternateOptionsRecoverAccountText
    case alternateOptionsRecoverAccountTappableText
    case alternateOptionsSignUpText
    case alternateOptionsSignUpTappableText
    case alternateOptionsVisitSupportText
    case alternateOptionsVisitSupportTappableText
    
    case credentialTitle
    case credentialDescription
    case credentialAcknowledge
    case credentialHandleError
    
    case loadingAuthenticationError
    case loadingAuthenticationErrorInfo
    
    case loadingLoginInitialMessage
    case loadingRecoverOrRegisterInitialMessage
    
    case loadingRegisterSuccess
    case loadingRegisterError
    case loadingRegisterErrorInfo
    
    case migrationEnterScreenTitle
    case migrationEnterDescription
    
    case migrationError
    
    case migrationCameraDisabled
    case migrationCameraEnableAccess
    
    case migrationScanScreenTitle
    case migrationScanDescription
    
    case migrationSwitchToEnter
    case migrationSwitchToScan
    case migrationSwitchToRecoverDescription
    
    case primaryButtonTitle
    case primaryButtonSubtitle
    case primaryButtonError
    
    case recoverScreenTitle
    case recoverDescription
    
    case settingScreenTitle
    case settingOptionAddCredential
    case settingOptionViewCredential
    case settingOptionShowQRCode
    case settingOptionShowQRCodeDetail
    
    case settingCredentialNotFoundError
    
    case settingAddCredentialTitle
    
    case settingAddCredentialInfo
    case settingCreateNewCredentialButton
    
    case settingCredentialSetUpInfo
    case settingCredentialSetUpButton
    
    case settingShowQRCodeTitle
    case settingShowQRCodeInfo
    case settingNoCameraCode
    
    case settingExtendCredentialsError
    case settingExtendCredentialsQRError
    
    case settingCancelExtendCredentialsError
    case settingCancelExtendCredentialsButton
    case settingCredentialInfoTitle
    case settingDeviceName
    case settingDeviceInfoTitle
    case settingDeviceInfoModel
    case settingDeviceInfoVersion
    case settingDeleteCredentialButton
    
    case settingDeleteWarningTitle
    case settingDeleteWarning
    case settingCancelButton
    case settingDeleteButton
    case settingDeleteCredentialError
    
    case signUpActionButton
    case signUpScreenTitle
    case signUpTitle
    
    case signUpCredentialAlreadyExisitsScreenTitle
    case signUpCredentialAlreadyExisitsTitle
    case signUpLoginInButton
    case signUpUseDifferentCredentialButton
    
    case signUpAddAnotherCredentialTitle
    case signUpAddAnotherCredentialDetail
    case signUpAddAnotherCredentialButton
    
    public var string: String {
        NSLocalizedString(self.rawValue, tableName: nil, bundle: .module, value: "not found", comment: "")
    }
    
    public func format(_ arguments: CVarArg...) -> String {
        let args = arguments.map {
            if let arg = $0 as? Int { return String(arg) }
            if let arg = $0 as? Float { return String(arg) }
            if let arg = $0 as? Double { return String(arg) }
            if let arg = $0 as? Int64 { return String(arg) }
            if let arg = $0 as? String { return String(arg) }
            
            return "(null)"
        } as [CVarArg]
        
        return String(format: self.string, arguments: args)
    }
    
}
