import UIKit
import Embedded

enum AuthResponse {
    case authenticate(TokenResponse)
    case authorize(AuthorizationCode)
}

class EmbeddedUILoggedInViewController: UIViewController {
    private let authResponse: AuthResponse
    
    init(authResponse: AuthResponse) {
        self.authResponse = authResponse
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "Embedded UI Home"
        
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .preferredFont(forTextStyle: .body)
        
        switch authResponse {
        case let .authenticate(tokenResponse):
            label.text = tokenResponse.description
        case let .authorize(authCode):
            label.text = "Authorization Code: \(authCode.value)"
        }
        
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
