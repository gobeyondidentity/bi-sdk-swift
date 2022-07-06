import Anchorage
import BeyondIdentityEmbedded
import UIKit
import SharedDesign

class ManageCredentialsViewController: ScrollableViewController {
    private let viewModel: EmbeddedViewModel
    
    let getCredentialsButton = makeButton(with: Localized.getCredentialsButton.string)
    let getCredentialsLabel = ResponseLabelView()
    
    var credentialToDelete: CredentialID?
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        view.backgroundColor = Colors.background.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardObserver()
        hideKeyboardWhenTappedOutside()
        
        getCredentialsButton.addTarget(self, action: #selector(getCredentials), for: .touchUpInside)
        
        let credentialTitle = UILabel().wrap().withText(Localized.credentialTitle.string).withFont(Fonts.largeTitle)
        
        let viewCredential = makeCard(
            title: Localized.viewCredentialTitle.string,
            text: Localized.credentialText.string,
            button: getCredentialsButton,
            responseLabel: getCredentialsLabel
        )
        
        let deleteCredential = Card(
            title: Localized.deleteTitle.string,
            detail: Localized.deleteText.string,
            cardView: InputView<CredentialID>(
                buttonTitle: Localized.deleteTitle.string,
                placeholder: Localized.deletePlaceholder.string
            ){ (id, callback) in
                Embedded.shared.deleteCredential(for: id) { result in
                    switch result {
                    case .success:
                        callback("Deleted Credential: \(id.value)")
                    case let .failure(error):
                        callback(error.localizedDescription)
                    }
                }
            }
        )
        
        let stack = UIStackView(arrangedSubviews: [
            credentialTitle,
            viewCredential,
            Line(),
            deleteCredential
        ]).vertical()
        stack.alignment = .fill
        stack.spacing = Spacing.padding
        
        contentView.addSubview(stack)
        
        stack.verticalAnchors == contentView.safeAreaLayoutGuide.verticalAnchors + Spacing.large
        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + Spacing.large
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

