import Anchorage
import AuthenticationServices
import BeyondIdentityEmbedded
import os
import SharedDesign
import UIKit

class AuthenticationViewController: ScrollableViewController {
    private let viewModel: EmbeddedViewModel
    let responseLabel = ResponseLabelView()
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        
        view.backgroundColor = Colors.background.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardObserver()
        hideKeyboardWhenTappedOutside()
        
        let authView = Card(
            title: Localized.authenticateTitle.string,
            detail: Localized.authenticateText.string,
            cardView: InputView<URL>(
                buttonTitle: Localized.authenticateTitle.string,
                placeholder: Localized.authenticateURLPlaceholder.string
            ){ [weak self] (url, callback) in
                guard let self = self else { return }
                Embedded.shared.authenticate(
                    url: url,
                    onSelectCredential: self.presentCredentialSelection) { result in
                        switch result {
                        case let .success(response):
                            callback(response.description)
                        case let .failure(error):
                            callback(error.localizedDescription)
                        }
                    }
            }
        )
        
        let stack = StackView(arrangedSubviews: [authView])
        stack.axis = .vertical
        stack.spacing = Spacing.section
        
        contentView.addSubview(stack)
        
        stack.verticalAnchors == contentView.safeAreaLayoutGuide.verticalAnchors + Spacing.large
        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + Spacing.large
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func presentCredentialSelection(_ credentials: [Credential], _ completion: @escaping (CredentialID?) -> Void) {
        let detailViewController = CredentialViewController(credentials: credentials, completion: completion)
        let nav = UINavigationController(rootViewController: detailViewController)
        nav.modalPresentationStyle = .pageSheet
        
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                if credentials.count > 3 {
                    sheet.detents = [.large()]
                }else {
                    sheet.detents = [.medium(), .large()]
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        present(nav, animated: true, completion: nil)
    }
}

extension AuthenticationViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession)
    -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
    }
}

class CredentialViewController: ScrollableViewController {
    let credentials: [Credential]
    let completion: (CredentialID?) -> Void
    
    init(credentials: [Credential], completion: @escaping (CredentialID?) -> Void) {
        self.credentials = credentials
        self.completion = completion
        super.init()
        
        view.backgroundColor = Colors.background.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let accountButtons: [SelectCredentialButton] = credentials.enumerated().map{ (i, credential) in
            let button = SelectCredentialButton(text: credential.identity.displayName)
            button.tag = i
            button.addTarget(self, action: #selector(selectCredential(_:)), for: .touchUpInside)
            return button
        }
        
        let stack = StackView(arrangedSubviews: accountButtons)
        stack.axis = .vertical
        stack.spacing = Spacing.padding
        
        contentView.addSubview(stack)
        
        stack.topAnchor == contentView.safeAreaLayoutGuide.topAnchor + Spacing.offsetFromTop(view)
        stack.bottomAnchor == contentView.safeAreaLayoutGuide.bottomAnchor
        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + Spacing.padding
    }
    
    @objc func selectCredential(_ sender: UIButton){
        guard sender.tag < credentials.endIndex && sender.tag >= credentials.startIndex else { return }
        let selectedCredentialID = credentials[sender.tag].id
        completion(selectedCredentialID)
        self.dismiss(animated: true)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
