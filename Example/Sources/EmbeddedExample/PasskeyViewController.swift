import Anchorage
import BeyondIdentityEmbedded
import Foundation
import SharedDesign
import UIKit

class PasskeyViewController: ScrollableViewController {
    let passkeys: [Passkey]
    let completion: (Passkey.Id?) -> Void
    private var selectedPasskeyID: Passkey.Id? = nil
    
    init(passkeys: [Passkey], completion: @escaping (Passkey.Id?) -> Void) {
        self.passkeys = passkeys
        self.completion = completion
        super.init()
        
        view.backgroundColor = Colors.background.value
        navigationItem.title = Localized.selectPasskeyTitle.string
    }
    override func viewDidDisappear(_ animated: Bool) {
        completion(selectedPasskeyID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let accountButtons: [SelectPasskeyButton] = passkeys.enumerated().map{ (i, passkey) in
            let button = SelectPasskeyButton(text: passkey.identity.displayName)
            button.tag = i
            button.addTarget(self, action: #selector(selectPasskey(_:)), for: .touchUpInside)
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
    
    @objc func selectPasskey(_ sender: UIButton){
        guard sender.tag < passkeys.endIndex && sender.tag >= passkeys.startIndex else { return }
        selectedPasskeyID = passkeys[sender.tag].id
        dismiss(animated: true)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
