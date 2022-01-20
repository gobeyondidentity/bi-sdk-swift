import Anchorage
import BeyondIdentityEmbedded
import os
import UIKit

class AuthenticationViewController: ScrollableViewController {
    private let viewModel: EmbeddedViewModel
    
    // Buttons
    let authorizeButton = makeButton(with: "Authorize")
    let authenticateUnsafeButton = makeButton(with: "Exchange code")
    let authenticateButton = makeButton(with: "Authenticate")
    let pkceButton = makeButton(with: "Generate PKCE Challenge")

    // Labels
    let authorizeLabel = UILabel().wrap()
    let authenticateUnsafeLabel = UILabel().wrap()
    let authenticateLabel = UILabel().wrap()
    let pkceLabel = UILabel().wrap()

    // User input
    var authCode: String?
    var pkce: PKCE?
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "Authenticate"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorizeButton.addTarget(self, action: #selector(authorize), for: .touchUpInside)
        authenticateUnsafeButton.addTarget(self, action: #selector(authenticateUnsafe), for: .touchUpInside)
        authenticateButton.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
        pkceButton.addTarget(self, action: #selector(getPKCE), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            UILabel().wrap().withTitle("OIDC Public Client"),
            UILabel().wrap().withTitle("Authenticate a user from a public client and receive a TokenResponse which will contain the access and id token. PKCE is handled internally to mitigate against an authorization code interception attack. This assumes there is no backend and the client secret can’t be safely stored.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            authenticateButton,
            authenticateLabel,
            UILabel().wrap().withTitle("OIDC Confidential Client"),
            UILabel().wrap().withTitle("Authorize a user from a confidential client and receive an AuthorizationCode to exchange for an access and id token.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            UILabel().wrap().withTitle("STEP 1: PKCE CHALLENGE (OPTIONAL)").withFont(UIFont.preferredFont(forTextStyle: .callout)),
            pkceButton,
            pkceLabel,
            UILabel().wrap().withTitle("STEP 2: AUTHORIZE").withFont(UIFont.preferredFont(forTextStyle: .callout)),
            authorizeButton,
            authorizeLabel,
            UILabel().wrap().withTitle("STEP 3: AUTHORIZATION CODE / TOKEN EXCHANGE").withFont(UIFont.preferredFont(forTextStyle: .callout)),
            UILabel().wrap().withTitle("Important Note: this should only be done for demo purposes. Use a back channel in production.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            authenticateUnsafeButton,
            authenticateUnsafeLabel,
        ]).vertical()

        contentView.addSubview(stack)

        stack.horizontalAnchors == contentView.horizontalAnchors + 16
        stack.verticalAnchors == contentView.verticalAnchors + 16
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
            authenticateUnsafeLabel.text = "First register a user and then complete \"Authorize\". This unsafe function will simulate your backend making the token exchange with the provided Authentication Code returned from \"Authorize\"."
            return
        }
                
        let parameters = "code=\(authCode)&code_verifier=\(pkce.codeVerifier)&redirect_uri=\(viewModel.redirectURI)&grant_type=authorization_code"
        let postData =  parameters.data(using: .utf8)
        
        let clientSecretBasic = "\(viewModel.confidentialClientID):\(viewModel.confidentialClientSecret)".data(using: .utf8)?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        guard let clientSecretBasic = clientSecretBasic else {
            authenticateUnsafeLabel.text = "Unable to base64 encode client secret"
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
                    self.authenticateUnsafeLabel.text = "Warning, this API call should happen in your backend. Do not store client secrets in your app. \n\n Result:\(result)"
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

