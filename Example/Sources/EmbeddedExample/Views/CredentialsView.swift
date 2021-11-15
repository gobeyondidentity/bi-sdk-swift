import BeyondIdentityEmbedded
import UIKit

class CredentialsView: UIView {
    let viewModel: EmbeddedViewModel

    // Buttons
    let deleteCredentialButton = makeButton(with: "Delete A Credential")
    let getCredentialsButton = makeButton(with: "Get All Credentials")

    // Labels
    let deleteCredentialLabel = UILabel().wrap()
    let getCredentialsLabel = UILabel().wrap()

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
        deleteCredentialButton.addTarget(self, action: #selector(deleteCredential), for: .touchUpInside)
        getCredentialsButton.addTarget(self, action: #selector(getCredentials), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            UILabel().wrap().withTitle("Credentials"),
            getCredentialsButton,
            getCredentialsLabel,
            deleteCredentialButton,
            deleteCredentialLabel,
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
    
    @objc func deleteCredential(){
        Embedded.shared.getCredentials { result in
            switch result {
            case let .success(credentials):
                guard let credential = credentials.first else {
                    self.deleteCredentialLabel.text = "No Credential found, create a user first"
                    return
                }
                Embedded.shared.deleteCredential(for: credential.handle) { result in
                    switch result {
                    case let .success(credential):
                        self.deleteCredentialLabel.text = "Deleted Credential: \(credential.value)"
                    case let .failure(error):
                        self.deleteCredentialLabel.text = error.localizedDescription
                    }
                }
            case let .failure(error):
                self.getCredentialsLabel.text = error.localizedDescription
            }
        }
    }
    
    @objc func getCredentials() {
        Embedded.shared.getCredentials { result in
            switch result {
            case let .success(credentials):
                guard !credentials.isEmpty else {
                    self.getCredentialsLabel.text = "No Credentials found, create a user first"
                    return
                }
                self.getCredentialsLabel.text = credentials.map({$0.description}).joined()
            case let .failure(error):
                self.getCredentialsLabel.text = error.localizedDescription
            }
        }
    }
}


