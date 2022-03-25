import Anchorage
import BeyondIdentityEmbedded
import os
import UIKit
import SharedDesign

class AuthenticationViewController: ScrollableViewController {
    private let viewModel: EmbeddedViewModel
    
    // Buttons
    let authorizeButton = makeButton(with: Localized.authorizeButton.string)
    let authenticateUnsafeButton = makeButton(with: Localized.authenticateUnsafeButton.string)
    let authenticateButton = makeButton(with: Localized.authenticateAuthButon.string)
    let pkceButton = makeButton(with: Localized.pkceButton.string)

    // Labels
    let authorizeLabel = UILabel().wrap()
    let authenticateUnsafeLabel = UILabel().wrap()
    let authenticateLabel = UILabel().wrap()
    let pkceLabel = UILabel().wrap()

    private let line = Line()
   
    // User input
    var authCode: String?
    var pkce: PKCE?
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorizeButton.addTarget(self, action: #selector(authorize), for: .touchUpInside)
        authenticateUnsafeButton.addTarget(self, action: #selector(authenticateUnsafe), for: .touchUpInside)
        authenticateButton.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
        pkceButton.addTarget(self, action: #selector(getPKCE), for: .touchUpInside)
        
        authorizeLabel.backgroundColor = .lightGray
        authenticateUnsafeLabel.backgroundColor = .lightGray
        authenticateLabel.backgroundColor = .lightGray
        pkceLabel.backgroundColor = .lightGray
        
        let stack = UIStackView(arrangedSubviews: [
            UILabel().wrap().withTitle(Localized.AuthenticateTitle.string).withFont(Fonts.largeTitle),
            UILabel().wrap().withTitle(Localized.accessText.string).withFont(Fonts.title2),
            UILabel().wrap().withTitle(Localized.oidcPublicText.string).withFont(Fonts.largeTitle),
            UILabel().wrap().withTitle(Localized.publicClientText.string).withFont(Fonts.title2),
            authenticateButton,
            authenticateLabel,
            line,
            UILabel().wrap().withTitle(Localized.oidcConfidentialText.string).withFont(Fonts.largeTitle),
            UILabel().wrap().withTitle(Localized.ConfidentialClientText.string).withFont(Fonts.title2),
            UILabel().wrap().withTitle(Localized.stepOneText.string).withFont(Fonts.navTitle),
            pkceButton,
            pkceLabel,
            UILabel().wrap().withTitle(Localized.stepTwoText.string).withFont(Fonts.navTitle),
            UILabel().wrap().withTitle(Localized.useAuthorizeText.string).withFont(Fonts.title2),
            authorizeButton,
            authorizeLabel,
            UILabel().wrap().withTitle(Localized.stepThreeText.string).withFont(Fonts.navTitle),
            UILabel().wrap().withTitle(Localized.clientSecretText.string).withFont(Fonts.title2),
            UILabel().wrap().withTitle(Localized.importantNoteText.string).withColor(UIColor.systemRed).withFont(Fonts.title2),
            authenticateUnsafeButton,
            authenticateUnsafeLabel,
        ]).vertical()

        contentView.addSubview(stack)

        stack.alignment = .fill
        stack.setCustomSpacing(16, after: authenticateLabel)
        stack.setCustomSpacing(32, after: line)

        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0)
        stack.verticalAnchors == contentView.safeAreaLayoutGuide.verticalAnchors - 16
        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + 16
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func authorize() {
        Embedded.initialize(
            biometricAskPrompt: viewModel.biometricAskPrompt,
            clientID: viewModel.confidentialClientID,
            redirectURI: viewModel.redirectURI,
            logger: {(type: OSLogType, message: String) in
                print(message)
            }
        )
        Embedded.shared.createPKCE { result in
            switch result {
            case let .success(pkce):
                self.pkce = pkce
                self.pkceLabel.text = pkce.description
                Embedded.shared.authorize(
                    pkceChallenge: pkce.codeChallenge,
                    scope: "openid"
                ) { result in
                    switch result {
                    case let .success(code):
                        self.authCode = code.value
                        print("Authorization Code: \(code.value)")
                        print("code verifier: \(pkce.codeVerifier)")
                        self.authorizeLabel.text = "Authorization Code: \(code.value)"
                    case let .failure(error):
                        self.authorizeLabel.text = error.localizedDescription
                    }
                }
            case let .failure(error):
                self.pkceLabel.text = error.localizedDescription
            }
        }
    }
    
    /// Warning: This demo is simulating what your confidential server can do. Never store a client secret in your app.
    @objc func authenticateUnsafe() {
        guard let authCode = authCode, let pkce = pkce else {
            authenticateUnsafeLabel.text = Localized.authenticateUnsafeText.string
            return
        }
                
        let parameters = "code=\(authCode)&code_verifier=\(pkce.codeVerifier)&redirect_uri=\(viewModel.redirectURI)&grant_type=authorization_code"
        let postData =  parameters.data(using: .utf8)
        
        let clientSecretBasic = "\(viewModel.confidentialClientID):\(viewModel.confidentialClientSecret)".data(using: .utf8)?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        guard let clientSecretBasic = clientSecretBasic else {
            authenticateUnsafeLabel.text = Localized.base64Error.string
            return
        }
        
        var request = URLRequest(url: viewModel.tokenEndpoint)
        // The example app is configured with `client_secret_basic`
        request.addValue("Basic \(clientSecretBasic)", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        URLSession.shared.dataTask(with: request){ (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.authenticateUnsafeLabel.text = error.localizedDescription
                }
            } else if response == nil {
                DispatchQueue.main.async {
                    self.authenticateUnsafeLabel.text = "Missing Response"
                }
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 200 {
                DispatchQueue.main.async {
                    self.authenticateUnsafeLabel.text = "Status Code \(statusCode)"
                }
            } else if let data = data, let result = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.authenticateUnsafeLabel.text = "\(result)"
                }
            } else {
                DispatchQueue.main.async {
                    self.authenticateUnsafeLabel.text = "Empty data"
                }
            }
        }.resume()

    }

    @objc func authenticate() {
        Embedded.initialize(
            biometricAskPrompt: viewModel.biometricAskPrompt,
            clientID: viewModel.publicClientID,
            redirectURI: viewModel.redirectURI,
            logger: {(type: OSLogType, message: String) in
                print(message)
            }
        )
        Embedded.shared.authenticate { result in
            switch result {
            case let .success(tokenResponse):
                self.authenticateLabel.text = tokenResponse.description
            case let .failure(error):
                self.authenticateLabel.text = error.localizedDescription
            }
        }
    }

    @objc func getPKCE() {
        Embedded.shared.createPKCE { result in
            switch result {
            case let .success(pkce):
                self.pkceLabel.text = pkce.description
            case let .failure(error):
                self.pkceLabel.text = error.localizedDescription
            }
        }
    }
}
