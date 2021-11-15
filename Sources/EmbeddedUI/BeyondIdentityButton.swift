import Anchorage
import BeyondIdentityEmbedded
import Foundation
import SharedDesign

#if os(iOS)
import UIKit

/// Beyond Identity Login Button
public class BeyondIdentityButton: View {
    
    /// Your app's authentication flow
    let authFlowType: FlowType
    
    /// structure holding required information and callbacks
    let config: BeyondIdentityConfig
    
    /// Intialize a BeyondIdentityButton
    /// - Parameters:
    ///   - authFlowType: Your app's authentication flow
    ///   - config: structure holding required information and callbacks
    public init(
        authFlowType: FlowType,
        config: BeyondIdentityConfig
    ){
        self.authFlowType = authFlowType
        self.config = config
        super.init(frame: .zero)
        
        setUpButton()
    }
    
    private func setUpButton() {
        let button = PrimaryButton(
            title: LocalizedString.primaryButtonTitle.string,
            subtitle: LocalizedString.primaryButtonSubtitle.string,
            backgroundColor: Color.clear,
            borderColor: Colors.border2.value,
            imageColor: Colors.primary.value,
            titleColor: Colors.border2.value,
            subtitleColor: Colors.body.value
        )
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        
        addSubview(button)
        
        button.horizontalAnchors == horizontalAnchors
        button.verticalAnchors == verticalAnchors
    }
    
    @objc private func signIn(){
        Embedded.shared.getCredentials { [weak self] result in
            guard let self = self else { return }
            
            var viewController: ViewController? = nil
            
            switch result {
            case let .success(credentials):
                if credentials.isEmpty {
                    viewController = SignUpViewController(
                        authType: self.authFlowType,
                        config: self.config,
                        type: .noCredential
                    )
                } else if credentials.count == 1 {
                    viewController = CredentialExistsViewController(
                        authFlowType: self.authFlowType,
                        config: self.config,
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
                
                if let parentVC = self.parentViewController, let rootVC = viewController {
                    parentVC.present(CustomNavigationController(rootViewController: rootVC), animated: true, completion: nil)
                }
            case let .failure(error):
                let alert = ErrorAlert(
                    title: LocalizedString.primaryButtonError.string,
                    message: error.localizedDescription,
                    responseTitle: LocalizedString.alertErrorAction.string
                )
                if let vc = self.parentViewController {
                    alert.show(with: vc)
                }
            }
            
        }
    }
    
    @available(*, unavailable)
    required init?(coder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif

class CustomNavigationController: NavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = Colors.background.value
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = Colors.background.value
        UINavigationBar.appearance().tintColor = Colors.navBarText.value
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: Fonts.navTitle]
    }
}
