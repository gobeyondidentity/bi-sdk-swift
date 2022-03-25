import Anchorage
import BeyondIdentityEmbedded
import UIKit
import SharedDesign

class ManageCredentialsViewController: ScrollableViewController {
    private let viewModel: EmbeddedViewModel
    
    let deleteCredentialButton = makeButton(with: Localized.deleteCredentialButton.string)
    let getCredentialsButton = makeButton(with: Localized.getCredentialsButton.string)

    let deleteCredentialLabel = UILabel().wrap()
    let getCredentialsLabel = UILabel().wrap()
    
    private let line = Line()
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCredentialsButton.addTarget(self, action: #selector(getCredentials), for: .touchUpInside)
        
        deleteCredentialButton.addTarget(self, action: #selector(deleteCredential), for: .touchUpInside)
        
        deleteCredentialLabel.backgroundColor = .lightGray
        getCredentialsLabel.backgroundColor = .lightGray

        let credentialTitle = UILabel().wrap().withTitle(Localized.credentialTitle.string).withFont(Fonts.largeTitle)
        let viewCredentialTitle = UILabel().wrap().withTitle(Localized.viewCredentialTitle.string).withFont(Fonts.navTitle)
        let credentialText = UILabel().wrap().withTitle(Localized.credentialText.string).withFont(Fonts.title2)
        let deleteTitle = UILabel().wrap().withTitle(Localized.deleteTitle.string).withFont(Fonts.navTitle)
        let deleteText = UILabel().wrap().withTitle(Localized.deleteText.string).withFont(Fonts.title2)

        let stack = UIStackView(arrangedSubviews: [
            credentialTitle,
            viewCredentialTitle,
            credentialText,
            getCredentialsButton,
            getCredentialsLabel,
            line,
            deleteTitle,
            deleteText,
            deleteCredentialButton,
            deleteCredentialLabel,
        ]).vertical()

        contentView.addSubview(stack)

        stack.alignment = .fill
        stack.setCustomSpacing(32, after: credentialTitle)
        stack.setCustomSpacing(16, after: getCredentialsLabel)
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
    
    @objc func deleteCredential(){
        Embedded.shared.getCredentials { result in
            switch result {
            case let .success(credentials):
                guard let credential = credentials.first else {
                    self.deleteCredentialLabel.text = Localized.noCredentialFound.string
                    return
                }
                guard let handle = credential.handle else {
                    self.getCredentialsLabel.text = Localized.missingHandle.string
                    return
                }
                Embedded.shared.deleteCredential(for: handle) { result in
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
                    self.getCredentialsLabel.text = Localized.noCredentialFound.string
                    return
                }
                self.getCredentialsLabel.text = credentials.map({$0.description}).joined()
            case let .failure(error):
                self.getCredentialsLabel.text = error.localizedDescription
            }
        }
    }
}

