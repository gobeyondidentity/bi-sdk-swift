import Embedded
import UIKit

class AuthenticationView: UIView {
    let viewModel: EmbeddedViewModel

    // Buttons
    let authorizeButton = makeButton(with: "Authorize")
    let authenticateUnsafeButton = makeButton(with: "Unsafe Authentication")
    let authenticateButton = makeButton(with: "Authenticate")
    let pkceButton = makeButton(with: "Generate PKCE Params")

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
        super.init(frame: .zero)
        
        setUpSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpSubviews() {
        authorizeButton.addTarget(self, action: #selector(authorize), for: .touchUpInside)
        authenticateUnsafeButton.addTarget(self, action: #selector(authenticateUnsafe), for: .touchUpInside)
        authenticateButton.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
        pkceButton.addTarget(self, action: #selector(getPKCE), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            UILabel().wrap().withTitle("Authentication"),
            pkceButton,
            pkceLabel,
            authorizeButton,
            authorizeLabel,
            authenticateUnsafeButton,
            authenticateUnsafeLabel,
            authenticateButton,
            authenticateLabel,
        ]).vertical()

        addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc func authorize() {
        Embedded.shared.createPKCE { result in
            switch result {
            case let .success(pkce):
                self.pkce = pkce
                self.pkceLabel.text = pkce.description
                Embedded.shared.authorize(
                    clientID: self.viewModel.confidentialClientID,
                    pkceChallenge: pkce.codeChallenge,
                    redirectURI: self.viewModel.redirectURI,
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
                
        let parameters = "code=\(authCode)&code_verifier=\(pkce.codeVerifier)&client_secret=\(viewModel.confidentialClientSecret)&redirect_uri=\(viewModel.redirectURI)&grant_type=authorization_code"
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
                    self.authenticateUnsafeLabel.text = "Warning, this API call would happen in your backend. Do not store client secrets in your app. \n\n Result:\(result)"
                }
            } else {
                DispatchQueue.main.async {
                    self.authenticateUnsafeLabel.text = "Empty data"
                }
            }
        }.resume()

    }

    @objc func authenticate() {
        Embedded.shared.authenticate(
            clientID: viewModel.publicClientID,
            redirectURI: viewModel.redirectURI
        ) { result in
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
