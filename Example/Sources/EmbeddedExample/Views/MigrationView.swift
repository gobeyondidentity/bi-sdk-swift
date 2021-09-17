import Embedded
import UIKit

class MigrationView: UIView {
    let viewModel: EmbeddedViewModel
    
    // Buttons
    let exportButton = makeButton(with: "Export Credential")
    let exportCancelButton = makeButton(with: "Cancel Export")
    let importButton = makeButton(with: "Import Credential")

    // Labels
    let exportLabel = UILabel().wrap()
    let exportCancelLabel = UILabel().wrap()
    let importLabel = UILabel().wrap()
    
    // TextFields
    let importField = UITextField().with(placeholder: "Enter token to import", type: .namePhonePad)

    // ExportStackView
    let exportView = UIStackView().vertical()

    // User input
    var tokenToImport: CredentialToken?
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setUpSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubviews() {
        exportButton.addTarget(self, action: #selector(export), for: .touchUpInside)
        exportCancelButton.addTarget(self, action: #selector(cancelExport), for: .touchUpInside)
        importButton.addTarget(self, action: #selector(importCredential), for: .touchUpInside)
        importField.addTarget(self, action: #selector(importFieldDidChange(_:)), for: .editingChanged)
        importField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEndOnExit)

        exportView.addArrangedSubview(exportButton)
        exportView.addArrangedSubview(exportLabel)
        
        let stack = UIStackView(arrangedSubviews: [
            UILabel().wrap().withTitle("Migration"),
            exportView,
            exportCancelButton,
            exportCancelLabel,
            importField,
            importButton,
            importLabel
        ]).vertical()

        addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc func cancelExport() {
        Embedded.shared.cancelExport { result in
            switch result {
            case .success:
                self.exportCancelLabel.text = "canceled"
            case let .failure(error):
                self.exportCancelLabel.text = error.localizedDescription
            }
        }
    }
    
    @objc func export() {
        // swiftlint:disable closure_body_length
        Embedded.shared.getCredentials { result in
            switch result {
            case let .success(Credentials):
                guard let firstCredential = Credentials.first else {
                    self.exportLabel.text = "Missing Credential, create a user first"
                    return
                }
                Embedded.shared.export(handles: [firstCredential.handle]) { result in
                    switch result {
                    case let .success(export):
                        switch export {
                        case let .started(token, qrcode),
                             let .tokenUpdated(token, qrcode):
                            self.exportLabel.text = "\(token)"
                            if let qrcode = qrcode {
                                let image = UIImageView(image: qrcode)
                                self.exportView.addArrangedSubview(image)
                            }
                        case .done:
                            self.exportLabel.text = "done"
                        }
                    case let .failure(error):
                        self.exportLabel.text = error.localizedDescription
                    }
                }

            case let .failure(error):
                self.exportLabel.text = error.localizedDescription
            }
        }
    }
    
    @objc func importCredential() {
        guard let tokenToImport = tokenToImport else {
            self.importLabel.text =
                """
                Export a token on another device.
                Then enter that token below to import on this device.
                """
            return
        }
        Embedded.shared.import(token: tokenToImport) { result in
            switch result {
            case let .success(credentials):
                self.importLabel.text = "\(credentials)"
            case let .failure(error):
                self.importLabel.text = error.localizedDescription
            }
        }
    }
    
    @objc func importFieldDidChange(_ textField: UITextField) {
        if let input = textField.text, !input.isEmpty {
            tokenToImport = CredentialToken(value: input)
        }
    }
    
    @objc func textFieldDidEnd(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
