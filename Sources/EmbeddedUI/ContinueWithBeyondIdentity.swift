import BeyondIdentityEmbedded
import Foundation
import SharedDesign

/// Call this function from your own button to present custom Beyond Identity UI and begin the passwordless experience
/// - Parameters:
///   - parentViewController: The ViewController that will present Beyond Identity custom UI to begin the passwordless experience
///   - authFlow: Your app's authentication flow
///   - config: A structure holding required information and callbacks
public func continueWithBeyondIdentity(for parentViewController: ViewController, authFlow: AuthFlowType, config: BeyondIdentityConfig){
    Embedded.shared.getCredentials { result in
        var viewController: ViewController? = nil
        
        switch result {
        case let .success(credentials):
            if credentials.isEmpty {
                viewController = SignUpViewController(
                    authType: authFlow,
                    config: config,
                    type: .noCredential
                )
            } else if credentials.count == 1 {
                viewController = CredentialExistsViewController(
                    authFlowType: authFlow,
                    config: config,
                    credentialExistsText: CredentialExistsView.TextConfig(
                        infoText: LocalizedString.signUpCredentialAlreadyExisitsTitle.string,
                        primaryText: LocalizedString.signUpLoginInButton.string,
                        secondaryText: LocalizedString.signUpUseDifferentCredentialButton.string
                    ),
                    screenType: .exisitingCredential
                )
            } else {
                // show selection, currently not supported
                break
            }
            
            if let rootViewController = viewController {
                parentViewController.present(CustomNavigationController(rootViewController: rootViewController), animated: true, completion: nil)
            }
        case let .failure(error):
            let alert = ErrorAlert(
                title: LocalizedString.primaryButtonError.string,
                message: error.localizedDescription,
                responseTitle: LocalizedString.alertErrorAction.string
            )
            
            alert.show(with: parentViewController)
        }
        
    }
}
