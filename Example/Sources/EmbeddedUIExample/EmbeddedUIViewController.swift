import BeyondIdentityEmbedded
import BeyondIdentityEmbeddedUI
import UIKit

class EmbeddedUIViewController: UIViewController {
    let authLabel = UILabel().wrap()
    let authSwitch = UISwitch()
    var authorizeButton: BeyondIdentityButton!
    var authenticateButton: BeyondIdentityButton!
    
    let viewModel: EmbeddedViewModel
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        authorizeButton = BeyondIdentityButton(
            authFlowType: .authorize(
                AuthorizeLoginConfig(
                    clientID: viewModel.confidentialClientID,
                    redirectURI: viewModel.redirectURI,
                    pkce: nil,
                    scope: "openid"),
                authorizeCompletion
            ),
            config: BeyondIdentityConfig(
                supportURL: viewModel.supportURL,
                signUpAction: signUpAction,
                recoverUserAction: recoverUserAction
            )
        )
        
        authenticateButton = BeyondIdentityButton(
            authFlowType: .authenticate(
                AuthenticateLoginConfig(
                    clientID: viewModel.publicClientID,
                    redirectURI: viewModel.redirectURI
                ),
                authenticationCompletion
            ),
            config: BeyondIdentityConfig(
                supportURL: viewModel.supportURL,
                signUpAction: signUpAction,
                recoverUserAction: recoverUserAction
            )
        )
        
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "Embedded UI Demo"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authSwitch.setOn(UserDefaults.getClientType() == .public, animated: true)
        authSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        
        setUserDefaultsAuthPreference()
        
        setAuthLabelText()
        
        setButton()
        
        let settingsEntry = makeButton(with: "Open Passwordless Settings Screen")
        settingsEntry.addTarget(self, action: #selector(openSetting), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [authSwitch, authLabel, authorizeButton, authenticateButton, settingsEntry])
        stack.axis = .vertical
        stack.spacing = 16
        stack.setCustomSpacing(50, after: authorizeButton)
        stack.setCustomSpacing(50, after: authenticateButton)
        
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
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
    
    @objc func stateChanged(switchState: UISwitch) {
        setUserDefaultsAuthPreference()
        setAuthLabelText()
        setButton()
    }
    
    func setAuthLabelText(){
        if authSwitch.isOn {
            authLabel.text = "Simulating Public Client"
        } else {
            authLabel.text = "Simulating Confidential Client"
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
