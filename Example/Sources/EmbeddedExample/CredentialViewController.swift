import Anchorage
import BeyondIdentityEmbedded
import Foundation
import SharedDesign
import UIKit

class CredentialViewController: ScrollableViewController {
    let credentials: [Credential]
    let completion: (CredentialID?) -> Void
    private var selectedCredentialID: CredentialID? = nil
    
    init(credentials: [Credential], completion: @escaping (CredentialID?) -> Void) {
        self.credentials = credentials
        self.completion = completion
        super.init()
        
        view.backgroundColor = Colors.background.value
        navigationItem.title = Localized.selectCredentialTitle.string
    }
    override func viewDidDisappear(_ animated: Bool) {
        completion(selectedCredentialID)
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
        selectedCredentialID = credentials[sender.tag].id
        dismiss(animated: true)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
