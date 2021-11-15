import UIKit
import BeyondIdentityEmbedded

enum AuthResponse {
    case authenticate(TokenResponse)
    case authorize(AuthorizationCode)
}

class EmbeddedUILoggedInViewController: ScrollableViewController {
    private let authResponse: AuthResponse
    
    init(authResponse: AuthResponse) {
        self.authResponse = authResponse
        super.init()
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
        
        let stack = UIStackView(arrangedSubviews: [label])
        stack.axis = .vertical
        
        contentView.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            stack.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stack.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
