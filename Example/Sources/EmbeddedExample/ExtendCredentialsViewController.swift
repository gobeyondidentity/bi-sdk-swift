import Anchorage
import BeyondIdentityEmbedded
import UIKit

class ExtendCredentialsViewController: ScrollableViewController {
    private let viewModel: EmbeddedViewModel
    
    // Buttons
    let extendButton = makeButton(with: "Extend Credentials")
    let extendCancelButton = makeButton(with: "Cancel Extending Credentials")
    let registerButton = makeButton(with: "Register Credentials")

    // Labels
    let extendLabel = UILabel().wrap()
    let extendCancelLabel = UILabel().wrap()
    let registerLabel = UILabel().wrap()
    
    // TextFields
    let registerField = UITextField().with(placeholder: "Enter token to register", type: .namePhonePad)

    // ExtendStackView
    let extendView = UIStackView().vertical()
    
    // User input
    var tokenToRegister: CredentialToken?
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "Import / Export Credentials"
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
        
        let stack = UIStackView(arrangedSubviews: [
            UILabel().wrap().withTitle("Extend Credential (Export)"),
            UILabel().wrap().withTitle("Extend the current device credential to another device.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            extendView,
            UILabel().wrap().withTitle("Cancel Credential Extension"),
            UILabel().wrap().withTitle("Stop the extend process.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            extendCancelButton,
            extendCancelLabel,
            UILabel().wrap().withTitle("Register Credential (Import)"),
            UILabel().wrap().withTitle("Register a Credential on this device with a token from another credential on another device.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            registerField,
            registerButton,
            registerLabel
        ]).vertical()

        contentView.addSubview(stack)

        stack.horizontalAnchors == contentView.horizontalAnchors + 16
        stack.verticalAnchors == contentView.verticalAnchors + 16
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelExtendCredentials() {
        Embedded.shared.cancelExtendCredentials { result in
            switch result {
            case .success:
                self.extendCancelLabel.text = "Canceled Extend"
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
                    self.extendLabel.text = "Missing Credential, register or recover a credential first"
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
