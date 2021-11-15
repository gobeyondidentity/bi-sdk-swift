//import Anchorage
//import BeyondIdentityEmbedded
//import SharedDesign
//
//#if os(iOS)
//import UIKit
//
//class EmailFormView: View {
//    enum EmailAction {
//        case signUp
//        case recover
//    }
//    
//    let emailAction: EmailAction
//    let emailField = TextFieldWithPadding()
//    let sendEmailButton: StandardButton
//    let errorMessage = Label().wrap().withFont(Fonts.body)
//    
//    let buttonAction: () -> Void
//    let token: String
//    
//    var userEmail: String? = nil
//    
//    init(for emailAction: EmailAction, token: String, buttonAction: @escaping () -> Void) {
//        self.emailAction = emailAction
//        self.token = token
//        self.buttonAction = buttonAction
//        
//        switch emailAction {
//        case .signUp:
//            sendEmailButton = StandardButton(title: LocalizedString.emailFormSignUpAction.string)
//            errorMessage.text = LocalizedString.emailFormSignUpError.string
//        case .recover:
//            sendEmailButton = StandardButton(title: LocalizedString.emailFormRecoverAction.string, state: .error)
//            errorMessage.text = LocalizedString.emailFormRecoverError.string
//        }
//        
//        super.init(frame: .zero)
//        setUpSubviews()
//    }
//    
//    private func setUpSubviews() {
//        setUpEmailField()
//        sendEmailButton.addTarget(self, action: #selector(tapSendEmailButton), for: .touchUpInside)
//        
//        errorMessage.textColor = Colors.error.value
//        errorMessage.textAlignment = .center
//        errorMessage.isHidden = true
//        
//        let stack = StackView(arrangedSubviews: [emailField, sendEmailButton, errorMessage])
//        stack.axis = .vertical
//        stack.spacing = Spacing.large
//        
//        addSubview(stack)
//        
//        stack.horizontalAnchors == horizontalAnchors
//        stack.verticalAnchors == verticalAnchors
//    }
//    
//    private func setUpEmailField() {
//        emailField.keyboardType = .emailAddress
//        emailField.backgroundColor = Colors.background.value
//        emailField.borderStyle = .roundedRect
//        emailField.autocapitalizationType = .none
//        emailField.autocorrectionType = .no
//        emailField.attributedPlaceholder = NSAttributedString(
//            string: LocalizedString.emailFormPlaceholder.string,
//            attributes: [.foregroundColor: Colors.formText.value])
//        emailField.textColor = Colors.formText.value
//        emailField.font = Fonts.body
//        emailField.returnKeyType = .send
//        
//        emailField.addTarget(self, action: #selector(emailFieldDidChange(_:)), for: .editingChanged)
//        emailField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEndOnExit)
//        emailField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
//    }
//    
//    @objc private func tapSendEmailButton() {
//        emailField.resignFirstResponder()
//        guard let email = userEmail, isValidEmail(email) else {
//            errorMessage.isHidden = false
//            return
//        }
//        
//        switch emailAction {
//        case .signUp:
//            createUser(with: email)
//        case .recover:
//            recoverUser(with: email)
//        }
//    }
//    
//    private func createUser(with email: String){
//        Embedded.shared.createUser(
//            apiToken: token,
//            externalID: email,
//            email: email,
//            userName: email,
//            displayName: email
//        ) { [weak self] result in
//            switch result {
//            case .success:
//                self?.buttonAction()
//            case .failure:
//                self?.errorMessage.isHidden = false
//            }
//        }
//    }
//    
//    private func recoverUser(with email: String){
//        Embedded.shared.recoverUser(apiToken: token, externalID: email) { [weak self] result in
//            switch result {
//            case .success:
//                self?.buttonAction()
//            case .failure:
//                self?.errorMessage.isHidden = false
//            }
//        }
//    }
//    
//    private func isValidEmail(_ email: String) -> Bool {
//        // strict regex http://emailregex.com
//        return email.contains("@")
//    }
//    
//    @objc func emailFieldDidChange(_ textField: UITextField) {
//        if let input = textField.text, !input.isEmpty {
//            userEmail = input
//        }
//    }
//    
//    @objc func textFieldDidEnd(_ textField: UITextField) {
//        textField.resignFirstResponder()
//        tapSendEmailButton()
//    }
//    
//    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
//        errorMessage.isHidden = true
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: Coder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//#endif
