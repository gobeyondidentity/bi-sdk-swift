import Anchorage
import Embedded
import Foundation
import SharedDesign

#if os(iOS)
import UIKit

enum Flow {
    case button(FlowType)
    case setting
}

class CodeEntryViewController: ScrollableViewController {
    private(set) var activeTextField = TextField()
    private(set) var textFields = [TextField]()
    
    private let config: BeyondIdentityConfig
    private let error = MigrationErrorLabel()
    private let flow: Flow
    
    private let switchToScanButton = Link(title: LocalizedString.migrationSwitchToScan.string, for: Fonts.body)
    
    init(
        cameraRestricted: Bool = false,
        config: BeyondIdentityConfig,
        flow: Flow
    ) {
        self.config = config
        self.flow = flow
        switchToScanButton.isHidden = cameraRestricted
        super.init()
        
        title = LocalizedString.migrationEnterScreenTitle.string
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.background.value
        
        setUpCodeEntryFields()
        
        let codeEntryView = setUpTextFieldView()
        
        error.isHidden = true
        
        let description = Label()
            .wrap()
            .withText(LocalizedString.migrationScanDescription.string)
            .withFont(Fonts.body)
            .withColor(Colors.body.value)
        
        description.textAlignment = .center
        
        switchToScanButton.addTarget(self, action: #selector(tapSwitchToScan), for: .touchUpInside)
        
        let recoverOption = RecoverInsteadOfMigrate(recoverUserAction: tapRecoverUser)
        
        let stack = StackView(arrangedSubviews: [codeEntryView, error, description, switchToScanButton, recoverOption])
        stack.axis = .vertical
        stack.spacing = Spacing.large
        stack.setCustomSpacing(Spacing.large, after: codeEntryView)
        stack.setCustomSpacing(Spacing.section, after: switchToScanButton)
        
        contentView.addSubview(stack)
        
        stack.topAnchor == contentView.safeAreaLayoutGuide.topAnchor + Spacing.offsetFromTop(view)
        stack.bottomAnchor <= contentView.safeAreaLayoutGuide.bottomAnchor
        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + Spacing.padding
    }
    
    func setUpTextFieldView() -> UIView {
        let textStack = StackView()
        textStack.spacing = Spacing.small
        textStack.distribution = .fillEqually
        
        for (index, field) in textFields.enumerated() {
            textStack.addArrangedSubview(field)
            if index == 2 || index == 5 {
                textStack.addArrangedSubview(Dash())
            }
        }
        
        return textStack
    }
    
    func setUpCodeEntryFields() {
        for index in 0...8 {
            let textField = CodeEntryTextField()
            textField.delegate = self
            textField.codeEntryDelegate = self
            textField.isEnabled = (index == 0)
            
            if index == 0 {
                textField.becomeFirstResponder()
            }
            
            textFields.append(textField)
        }
    }
    
    @objc func tapSwitchToScan() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tapRecoverUser() {
        navigationController?.dismiss(animated: true, completion: { [weak self] in
            self?.config.recoverUserAction()
        })
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CodeEntryViewController: UITextFieldDelegate, CodeEntryTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        if error.isHidden == false {
            error.isHidden = true
            resetTextFields()
        }
    }
    
    func textFieldDidDelete() {
        guard let index = textFields.firstIndex(of: activeTextField) else { return }
        
        // do nothing for the first text field
        if index == 0 { return }
        
        let current = textFields[index]
        let previous = textFields[index - 1]
        current.isEnabled = false
        previous.isEnabled = true
        previous.becomeFirstResponder()
        previous.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let index = textFields.firstIndex(of: textField) else { return false }
        
        textField.text = string
        
        // Submit code immediately after entering the last number
        if index == textFields.count - 1 {
            submitCode()
            textField.resignFirstResponder()
            setAllToActive()
            return false
        }
        
        let next = textFields[index + 1]
        textField.isEnabled = false
        next.isEnabled = true
        next.becomeFirstResponder()
        
        return false
    }
    
    // Enable all to tap anywhere to begin another entry after an error
    func setAllToActive() {
        for textField in textFields {
            textField.isEnabled = true
        }
    }
    
    func resetTextFields() {
        for textField in textFields {
            textField.text = ""
            textField.isEnabled = false
        }
        guard let first = textFields.first else { return }
        first.isEnabled = true
        DispatchQueue.main.async {
            first.becomeFirstResponder()
        }
    }
    
    func submitCode() {
        let code = textFields.map{ $0.text ?? "" }.joined(separator: "")
        
        Embedded.shared.importCredentials(token: CredentialToken(value: code)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.error.isHidden = true
                handleImportSuccess(
                    for: self.flow,
                    with: self.navigationController,
                    config: self.config
                )
            case .failure:
                self.error.isHidden = false
            }
        }
    }
}

func handleImportSuccess(
    for flow: Flow,
    with navigationController: UINavigationController?,
    config: BeyondIdentityConfig
) {
    switch flow {
    case let .button(authType):
        let loadingVC = LoadingViewController(
            for: .importCredential(authType),
            appName:  config.appName,
            supportURL: config.supportURL,
            recoverUserAction: config.recoverUserAction
        )
        navigationController?.pushViewController(loadingVC, animated: true)
    case .setting:
        let loadingVC = LoadingViewController(
            for: .importCredentialWithoutAuth,
            appName: config.appName,
            supportURL: config.supportURL,
            recoverUserAction: config.recoverUserAction
        )
        navigationController?.pushViewController(loadingVC, animated: true)
    }
}
#endif


