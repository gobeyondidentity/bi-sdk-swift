import Anchorage
import BeyondIdentityEmbedded
import Foundation
import SharedDesign

#if os(iOS)
import UIKit

/// Begins Beyond Identity's custom UI Passwordless flow
public class BeyondIdentityButton: View {
    
    let authFlow: AuthFlowType
    let config: BeyondIdentityConfig
    
    /// Intialize a BeyondIdentityButton
    /// - Parameters:
    ///   - authFlowType: Your app's authentication flow
    ///   - config: structure holding required information and callbacks
    public init(
        authFlow: AuthFlowType,
        config: BeyondIdentityConfig
    ){
        self.authFlow = authFlow
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
        if let parentVC = self.parentViewController {
            continueWithBeyondIdentity(for: parentVC, authFlow: authFlow, config: config)
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
