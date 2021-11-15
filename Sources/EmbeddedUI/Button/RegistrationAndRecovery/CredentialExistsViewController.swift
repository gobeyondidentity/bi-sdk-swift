import Anchorage
import BeyondIdentityEmbedded
import SharedDesign

#if os(iOS)
import UIKit

class CredentialExistsViewController: ScrollableViewController {
    enum Screen: Equatable {
        case exisitingCredential
        case addAnotherCredential
    }
    
    let authFlowType: FlowType
    let config: BeyondIdentityConfig
    let credentialExistsText: CredentialExistsView.TextConfig
    let screenType: Screen
    
    init(
        authFlowType: FlowType,
        config: BeyondIdentityConfig,
        credentialExistsText: CredentialExistsView.TextConfig,
        screenType: Screen
    ) {
        self.authFlowType = authFlowType
        self.config = config
        self.credentialExistsText = credentialExistsText
        self.screenType = screenType
        
        super.init()
        
        title = LocalizedString.signUpCredentialAlreadyExisitsScreenTitle.string
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.background.value
        
        let credentialExistsView = CredentialExistsView(
            textConfig: credentialExistsText,
            primaryAction: tapPrimaryButton,
            secondaryAction: tapSecondaryButton
        )
        
        let poweredByBILogo = ImageView(image: .poweredByBILogo)
        poweredByBILogo.contentMode = .scaleAspectFit
        poweredByBILogo.setImageColor(color: Colors.body.value)
        
        let stack = StackView(arrangedSubviews: [
            credentialExistsView,
            poweredByBILogo
        ])
        stack.axis = .vertical
        stack.spacing = Spacing.padding
        
        contentView.addSubview(stack)
        
        stack.topAnchor == contentView.safeAreaLayoutGuide.topAnchor + Spacing.offsetFromTop(view)
        stack.bottomAnchor == contentView.safeAreaLayoutGuide.bottomAnchor
        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + Spacing.padding
    }
    
    private func tapPrimaryButton() {
        switch screenType {
        case .exisitingCredential:
            tapLogIn()
        case .addAnotherCredential:
            navigationController?.dismiss(animated: true, completion: { [weak self] in
                self?.config.signUpAction()
            })
        }
    }
    
    private func tapSecondaryButton() {
        let signUpVC = SignUpViewController(
            authType: authFlowType,
            config: config,
            type: .existingCredential
        )
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    private func tapLogIn(){
        let loginVC = LoadingViewController(
            for: .login(authFlowType),
            appName: config.appName,
            supportURL: config.supportURL,
            recoverUserAction: config.recoverUserAction
        )
        
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
