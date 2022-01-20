import Anchorage
import BeyondIdentityEmbedded
import BeyondIdentityEmbeddedUI
import os
import UIKit

class EmbeddedUIViewController: ScrollableViewController {
    let authLabel = UILabel().wrap()
    let authSwitch = UISwitch()
    var authorizeButton: BeyondIdentityButton!
    var authenticateButton: BeyondIdentityButton!
    var authorizeFlowType: AuthFlowType!
    var authenticateFlowType: AuthFlowType!
    var config: BeyondIdentityConfig!
    
    let viewModel: EmbeddedViewModel
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        
        authorizeFlowType = .authorize(
            pkce: nil,
            scope: "openid",
            callback: authorizeCompletion
        )
        
        authenticateFlowType = .authenticate(callback: authenticationCompletion)
        
        config = BeyondIdentityConfig(
            supportURL: viewModel.supportURL,
            signUpAction: signUpAction,
            recoverUserAction: recoverUserAction
        )
        
        authorizeButton = BeyondIdentityButton(
            authFlow: authorizeFlowType,
            config: config
        )
        
        authenticateButton = BeyondIdentityButton(
            authFlow: authenticateFlowType,
            config: config
        )
        
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "Embedded UI Demo"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authSwitch.setOn(UserDefaults.getClientType() == .public, animated: true)
        authSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        
        setValuesForState()
        
        let settingsEntry = makeButton(with: "Open Passwordless Settings Screen")
        settingsEntry.addTarget(self, action: #selector(openSetting), for: .touchUpInside)
        
        let continueWithBeyondIdentityEntry = makeButton(with: "Open Continue With Beyond Identity")
        continueWithBeyondIdentityEntry.addTarget(self, action: #selector(tapContinueWithBeyondIdentity), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [
            UILabel().wrap().withTitle("Simulate an OIDC client"),
            authSwitch,
            authLabel,
            UILabel().wrap().withTitle("SDK View"),
            UILabel().wrap().withTitle("Beyond Identity button view. A wrapper around the Embedded SDK. When tapped the Passwordless flow begins with custom Beyond Identity UI.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            authorizeButton,
            authenticateButton,
            UILabel().wrap().withTitle("SDK Functionality"),
            UILabel().wrap().withTitle("Begin the Passwordless flow with custom Beyond Identity UI from your own button.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            continueWithBeyondIdentityEntry,
            UILabel().wrap().withTitle("Open a Beyond Identity Settings Screen").withFont(UIFont.preferredFont(forTextStyle: .body)),
            settingsEntry,
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.setCustomSpacing(30, after: authorizeButton)
        stack.setCustomSpacing(30, after: authenticateButton)
        
        contentView.addSubview(stack)

        stack.horizontalAnchors == contentView.horizontalAnchors + 16
        stack.verticalAnchors == contentView.verticalAnchors + 16
    }
    
    func recoverUserAction(){
        let recoverVC = RecoverViewController(recoveryURL: viewModel.recoverUserEndpoint)
        navigationController?.pushViewController(
            recoverVC,
            animated: true
        )
    }
    
    func signUpAction(){
        navigationController?.pushViewController(
            SignUpViewController(registrationURL: viewModel.registrationEndpoint),
            animated: true
        )
    }
    
    func authenticationCompletion(_ tokenResponse: TokenResponse) {
        navigationController?.pushViewController(
            EmbeddedUILoggedInViewController(authResponse: .authenticate(tokenResponse)),
            animated: true
        )
    }
    
    func authorizeCompletion(_ authCode: AuthorizationCode) {
        navigationController?.pushViewController(
            EmbeddedUILoggedInViewController(authResponse: .authorize(authCode)),
            animated: true
        )
    }
    
    @objc func openSetting(){
        openBeyondIdentitySettings(
            with: self,
            config: BeyondIdentityConfig(
                supportURL: viewModel.supportURL,
                signUpAction: signUpAction,
                recoverUserAction: recoverUserAction
            )
        )
    }
    
    @objc func tapContinueWithBeyondIdentity() {
        if authSwitch.isOn {
            continueWithBeyondIdentity(for: self.parent!, authFlow: authenticateFlowType, config: config)
        } else {
            continueWithBeyondIdentity(for: self.parent!, authFlow: authorizeFlowType, config: config)
        }
    }
    
    @objc func stateChanged(switchState: UISwitch) {
        setValuesForState()
    }
    
    func setValuesForState(){
        setUserDefaultsAuthPreference()
        setAuthLabelText()
        setButton()
        setCorrectClientIDForDemo()
    }
    
    func setAuthLabelText(){
        if authSwitch.isOn {
            authLabel.text = "Simulating Public Client"
        } else {
            authLabel.text = "Simulating Confidential Client"
        }
    }
    
    func setCorrectClientIDForDemo(){
        if authSwitch.isOn {
            initializeBeyondIdentity(
                biometricAskPrompt: viewModel.biometricAskPrompt,
                clientID: viewModel.publicClientID,
                redirectURI: viewModel.redirectURI,
                logger: {(type: OSLogType, message: String) in
                    print(message)
                }
            )
        } else {
            initializeBeyondIdentity(
                biometricAskPrompt: viewModel.biometricAskPrompt,
                clientID: viewModel.confidentialClientID,
                redirectURI: viewModel.redirectURI,
                logger: {(type: OSLogType, message: String) in
                    print(message)
                }
            )
        }
    }
    
    func setUserDefaultsAuthPreference() {
        if authSwitch.isOn {
            UserDefaults.set(.public)
        } else {
            UserDefaults.set(.confidential)
        }
    }
    
    func setButton(){
        authorizeButton.isHidden = authSwitch.isOn
        authenticateButton.isHidden = !authSwitch.isOn
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
