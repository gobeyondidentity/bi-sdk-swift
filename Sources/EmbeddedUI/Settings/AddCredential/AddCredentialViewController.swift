import Anchorage
import SharedDesign

#if os(iOS)
import UIKit

class AddCredentialViewController: ScrollableViewController {
    private let config: BeyondIdentityConfig
    
    init(
        config: BeyondIdentityConfig
    ) {
        self.config = config
        super.init()
        
        title = LocalizedString.settingAddCredentialTitle.string
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background.value
        
        let info = Label()
            .wrap()
            .withText(LocalizedString.settingAddCredentialInfo.string)
            .withFont(Fonts.body)
            .withColor(Colors.body.value)
        
        let createNewCredentialButton = StandardButton(title: LocalizedString.settingCreateNewCredentialButton.string)
        createNewCredentialButton.addTarget(self, action: #selector(tappedCreateNewCredential), for: .touchUpInside)
        
        let addToDevice = TextView()
        addToDevice.setTappableText(with: self, text: LocalizedString.alternateOptionsAddDeviceText.string, tappableText: LocalizedString.alternateOptionsAddDeviceTappableText.string, for: .addToDevice)
        
        let stack = StackView(arrangedSubviews: [info, createNewCredentialButton, addToDevice])
        stack.axis = .vertical
        stack.setCustomSpacing(Spacing.section, after: info)
        stack.setCustomSpacing(Spacing.large, after: createNewCredentialButton)
        
        contentView.addSubview(stack)
        
        stack.topAnchor == contentView.safeAreaLayoutGuide.topAnchor + Spacing.padding
        stack.bottomAnchor <= contentView.safeAreaLayoutGuide.bottomAnchor
        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + Spacing.padding
    }
    
    @objc func tappedCreateNewCredential(){
        navigationController?.dismiss(animated: true, completion: { [weak self] in
            self?.config.signUpAction()
        })
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddCredentialViewController: TextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard let option = UITextView.TappableOption(rawValue: url.absoluteString) else { return false }
        
        switch option {
        case .addToDevice:
            navigateToAddDevice(
                with: navigationController,
                for: .setting,
                config: config
            )
        case .recoverAccount:
            break
        case .visitSupport:
            break
        }
        
        return false
    }
}
#endif
