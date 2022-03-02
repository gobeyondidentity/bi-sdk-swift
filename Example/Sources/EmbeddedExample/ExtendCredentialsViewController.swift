import Anchorage
import BeyondIdentityEmbedded
import UIKit

class ExtendCredentialsViewController: ScrollableViewController {
    private let viewModel: EmbeddedViewModel
    
    // Buttons
    let extendButton = makeButton(with: Localized.extendButton.string)
    let extendCancelButton = makeButton(with: Localized.extendCancelButton.string)
    let registerButton = makeButton(with: Localized.registerButton.string)

    // Labels
    let extendLabel = UILabel().wrap()
    let extendCancelLabel = UILabel().wrap()
    let registerLabel = UILabel().wrap()
    lazy var customLine: CustomUiLine = {
        let line = CustomUiLine()
        return line
    }()
    lazy var cancelCustomLine: CustomUiLine = {
        let line = CustomUiLine()
        return line
    }()
    
    // TextFields
    let registerField = UITextField().with(placeholder: Localized.registerField.string, type: .namePhonePad)

    // ExtendStackView
    let extendView = UIStackView().vertical()
    
    // User input
    var tokenToRegister: CredentialToken?
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedOutside()
        
        extendButton.addTarget(self, action: #selector(extendCredential), for: .touchUpInside)
        extendCancelButton.addTarget(self, action: #selector(cancelExtendCredentials), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerCredentials), for: .touchUpInside)
        registerField.addTarget(self, action: #selector(registerFieldDidChange(_:)), for: .editingChanged)
        registerField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEndOnExit)

        extendView.addArrangedSubview(extendButton)
        extendView.addArrangedSubview(extendLabel)

        let registerTitle = UILabel().wrap().withTitle(Localized.extendRegisterTitle.string).withFont(UIFont(name: OverpassFontNames.bold.rawValue, size: Size.largeTitle) ??  UIFont.systemFont(ofSize: Size.largeTitle))
        let registerText = UILabel().wrap().withTitle(Localized.extendRegisterText.string).withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))
        let extendTitle =  UILabel().wrap().withTitle(Localized.extendTitle.string).withFont(UIFont(name: OverpassFontNames.bold.rawValue, size: Size.largeTitle) ??  UIFont.systemFont(ofSize: Size.largeTitle))
        let extendText = UILabel().wrap().withTitle(Localized.extendText.string).withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))
        let noteText = UILabel().wrap().withTitle(Localized.noteText.string).withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))
        let cancelTitle = UILabel().wrap().withTitle(Localized.cancelTitle.string).withFont(UIFont(name: OverpassFontNames.bold.rawValue, size: Size.largeTitle) ??  UIFont.systemFont(ofSize: Size.largeTitle))
        let cancelText = UILabel().wrap().withTitle(Localized.cancelText.string).withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))
        let registerCredentialTitle = UILabel().wrap().withTitle(Localized.registerCredentialTitle.string).withFont(UIFont(name: OverpassFontNames.bold.rawValue, size: Size.largeTitle) ??  UIFont.systemFont(ofSize: Size.largeTitle))
        let registerCredentialText = UILabel().wrap().withTitle(Localized.registerCredentialText.string).withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))

        let stack = UIStackView(arrangedSubviews: [
            registerTitle,
            registerText,
            extendTitle,
            extendText,
            noteText,
            extendButton,
            extendLabel,
            extendView,
            customLine,
            cancelTitle,
            cancelText,
            extendView,
            extendCancelButton,
            extendCancelLabel,
            cancelCustomLine,
            registerCredentialTitle,
            registerCredentialText,
            registerField,
            registerButton,
            registerLabel
        ]).vertical()

        contentView.addSubview(stack)

        stack.alignment = .fill
        stack.setCustomSpacing(32, after: registerText)
        stack.setCustomSpacing(32, after: extendText)
        stack.setCustomSpacing(16, after: extendLabel)
        stack.setCustomSpacing(32, after: customLine)
        stack.setCustomSpacing(16, after: extendCancelLabel)
        stack.setCustomSpacing(32, after: cancelCustomLine)

        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0)
        stack.verticalAnchors == contentView.safeAreaLayoutGuide.verticalAnchors - 16
        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + 16

    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelExtendCredentials() {
        Embedded.shared.cancelExtendCredentials { result in
            switch result {
            case .success:
                self.extendCancelLabel.text = Localized.cancelExtendCredentials.string
            case let .failure(error):
                self.extendCancelLabel.text = error.localizedDescription
            }
        }
    }
    
    @objc func extendCredential() {
        // swiftlint:disable closure_body_length
        Embedded.shared.getCredentials { result in
            switch result {
            case let .success(Credentials):
                guard let firstCredential = Credentials.first else {
                    self.extendLabel.text = Localized.missingCredential.string
                    return
                }
                Embedded.shared.extendCredentials(handles: [firstCredential.handle]) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case let .success(extend):
                        switch extend {
                        case .aborted:
                            self.resetExportView()
                            self.extendLabel.text = "aborted"
                        case let .started(token, qrcode),
                             let .tokenUpdated(token, qrcode):
                            self.resetExportView()
                            self.updateView(with: token, qrcode)
                        case .done:
                            self.resetExportView()
                            self.extendLabel.text = "done"
                        }
                    case let .failure(error):
                        self.resetExportView()
                        self.extendLabel.text = error.localizedDescription
                    }
                }

            case let .failure(error):
                self.extendLabel.text = error.localizedDescription
            }
        }
    }
    
    private func resetExportView(){
        extendView.clear()
        extendView.addArrangedSubview(extendButton)
        extendView.addArrangedSubview(extendLabel)
    }
    
    private func updateView(with token: CredentialToken, _ qrcode: QRCode?) {
        extendLabel.text = "\(token)"
        let QRCodeImage = UIImageView(image: qrcode)
        extendView.addArrangedSubview(QRCodeImage)
    }
    
    @objc func registerCredentials() {
        guard let tokenToRegister = tokenToRegister else {
            self.registerLabel.text =
                """
                First: Extend a Credential from another device.
                
                Next: Enter that token to register the Credential on this device.
                """
            return
        }
        Embedded.shared.registerCredentials(token: tokenToRegister) { result in
            switch result {
            case let .success(credentials):
                self.registerLabel.text = "\(credentials)"
            case let .failure(error):
                self.registerLabel.text = error.localizedDescription
            }
        }
    }
    
    @objc func registerFieldDidChange(_ textField: UITextField) {
        if let input = textField.text, !input.isEmpty {
            tokenToRegister = CredentialToken(value: input)
        }
    }
    
    @objc func textFieldDidEnd(_ textField: UITextField) {
        textField.resignFirstResponder()
        registerCredentials()
    }
}

extension UIStackView {
    func clear() {
        for arrangedSubview in self.arrangedSubviews {
            self.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
    }
}
