import Anchorage
import BeyondIdentityEmbedded
import UIKit

class ManageCredentialsViewController: ScrollableViewController {
    private let viewModel: EmbeddedViewModel
    
    // Buttons
    let deleteCredentialButton = makeButton(with: "Delete A Credential")
    let getCredentialsButton = makeButton(with: "Get All Credentials")

    // Labels
    let deleteCredentialLabel = UILabel().wrap()
    let getCredentialsLabel = UILabel().wrap()
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "Credential Management"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        deleteCredentialButton.addTarget(self, action: #selector(deleteCredential), for: .touchUpInside)
        getCredentialsButton.addTarget(self, action: #selector(getCredentials), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            UILabel().wrap().withTitle("View Credentials"),
            UILabel().wrap().withTitle("Display all current credentials on this device.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            getCredentialsButton,
            getCredentialsLabel,
            UILabel().wrap().withTitle("Delete Credential"),
            UILabel().wrap().withTitle("This is destructive and will remove the current credential from this device. If no other device contains the Credential to extend it back to this device, then the Credential will be lost unless a recovery is done.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            deleteCredentialButton,
            deleteCredentialLabel,
        ]).vertical()

        contentView.addSubview(stack)

        stack.horizontalAnchors == contentView.horizontalAnchors + 16
        stack.verticalAnchors == contentView.verticalAnchors + 16
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteCredential(){
        Embedded.shared.getCredentials { result in
            switch result {
            case let .success(credentials):
                guard let credential = credentials.first else {
                    self.deleteCredentialLabel.text = "No Credential found, register or recover a credential first"
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
                    self.getCredentialsLabel.text = "No Credentials found, register or recover a credential first"
                    return
                }
                self.getCredentialsLabel.text = credentials.map({$0.description}).joined()
            case let .failure(error):
                self.getCredentialsLabel.text = error.localizedDescription
            }
        }
    }
}

