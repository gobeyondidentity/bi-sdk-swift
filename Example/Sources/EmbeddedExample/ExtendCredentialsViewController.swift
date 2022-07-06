import Anchorage
import BeyondIdentityEmbedded
import UIKit
import SharedDesign

class ExtendCredentialsViewController: ScrollableViewController {
    private let viewModel: EmbeddedViewModel
    
    let extendLabel = ResponseLabelView()
    let extendCancelLabel = ResponseLabelView()
    let registerLabel = ResponseLabelView()
    
    let QRCodeView = UIStackView().vertical()
    
    var tokenToRegister: CredentialToken?
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        
        view.backgroundColor = Colors.background.value
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cancelExtendCredentials()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedOutside()
        
        let title = UILabel().wrap().withText(Localized.extendRegisterTitle.string).withFont(Fonts.largeTitle)
        let detail = UILabel().wrap().withText(Localized.extendRegisterText.string).withFont(Fonts.title2)
        
        let titleStack = UIStackView(arrangedSubviews: [title, detail]).vertical()
        
        let extendCredential = makeExtendCard(
            title: Localized.extendTitle.string,
            text: Localized.extendText.string,
            note: Localized.noteText.string
        )
        
        let cancelCredential = makeCancelCard(
            title: Localized.cancelTitle.string,
            text: Localized.cancelText.string
        )
        
        let registerCredential = makeRegisterCard(
            title: Localized.registerCredentialTitle.string,
            text: Localized.registerCredentialText.string
        )
        
        let stack = UIStackView(arrangedSubviews: [
            titleStack,
            extendCredential,
            Line(),
            cancelCredential,
            Line(),
            registerCredential,
        ]).vertical()
        
        contentView.addSubview(stack)
        
        stack.alignment = .fill
        stack.spacing = Spacing.padding
        stack.setCustomSpacing(Spacing.large, after: extendCredential)
        
        stack.verticalAnchors == contentView.safeAreaLayoutGuide.verticalAnchors + Spacing.large
        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + Spacing.large
    }
    
    func makeExtendCard(title: String, text: String, note: String) -> View {
        let title = UILabel().wrap().withText(title).withFont(Fonts.title)
        let text = UILabel().wrap().withText(text).withFont(Fonts.title2)
        let note = UILabel().wrap().withText(note).withFont(Fonts.title2)
        let button = makeButton(with: Localized.extendButton.string)
        button.addTarget(self, action: #selector(extendCredential), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [
            title,
            text,
            note,
            button,
            extendLabel,
            QRCodeView,
        ]).vertical()
        
        stack.alignment = .fill
        stack.spacing = Spacing.large
        return stack
    }
    
    func makeCancelCard(title: String, text: String) -> View {
        let title = UILabel().wrap().withText(title).withFont(Fonts.title)
        let text =  UILabel().wrap().withText(text).withFont(Fonts.title2)
        let button = makeButton(with: Localized.extendCancelButton.string)
        button.addTarget(self, action: #selector(cancelExtendCredentials), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [
            title,
            text,
            button,
            extendCancelLabel
        ]).vertical()
        
        stack.alignment = .fill
        stack.spacing = Spacing.large
        return stack
    }
    
    func makeRegisterCard(title: String, text: String) -> View {
        let title = UILabel().wrap().withText(title).withFont(Fonts.title)
        let text = UILabel().wrap().withText(text).withFont(Fonts.title2)
        
        let registerField = UITextField().with(placeholder: Localized.registerField.string, type: .namePhonePad)
        registerField.addTarget(self, action: #selector(registerFieldDidChange(_:)), for: .editingChanged)
        registerField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEndOnExit)
        
        let button = makeButton(with: Localized.registerButton.string)
        button.addTarget(self, action: #selector(registerCredential), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [
            title,
            text,
            registerField,
            button,
            registerLabel,
        ]).vertical()
        
        stack.alignment = .fill
        stack.spacing = Spacing.large
        return stack
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelExtendCredentials() {
        Embedded.shared.cancelExtendCredential { result in
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
                Embedded.shared.extendCredential(id: firstCredential.id.value) { [weak self] result in
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
        QRCodeView.clear()
    }
    
    private func updateView(with token: CredentialToken, _ qrcode: QRCode?) {
        extendLabel.text = "\(token)"
        let QRCodeImage = UIImageView(image: qrcode)
        QRCodeView.addArrangedSubview(QRCodeImage)
    }
    
    @objc func registerCredential() {
        guard let tokenToRegister = tokenToRegister else {
            self.registerLabel.text =
                """
                First: Extend a Credential from another device.
                
                Next: Enter that token to register the Credential on this device.
                """
            return
        }
        Embedded.shared.registerCredential(token: tokenToRegister) { result in
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
        registerCredential()
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
