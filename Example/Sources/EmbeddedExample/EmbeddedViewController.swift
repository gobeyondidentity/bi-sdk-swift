import BeyondIdentityEmbedded
import UIKit

class EmbeddedViewController: ScrollableViewController {
    let viewModel: EmbeddedViewModel
    
    let createUserEmailField = UITextField().with(placeholder: "Email address", type: .emailAddress)
    var createUserEmail: String?
    let createUserButton = makeButton(with: "Register credential")
    let createUserLabel = UILabel().wrap()
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "Embedded SDK Demo"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedOutside()
        
        let manageCredentialsButton = makeButton(with: "Manage Credentials")
        manageCredentialsButton.addTarget(self, action: #selector(toManageCredentials), for: .touchUpInside)
        
        let extendCredentialsButton = makeButton(with: "Extend Credentials")
        extendCredentialsButton.addTarget(self, action: #selector(toExtendCredentials), for: .touchUpInside)
        
        let authenticationButton = makeButton(with: "Authentication")
        authenticationButton.addTarget(self, action: #selector(toAuthentication), for: .touchUpInside)
        
        createUserButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        createUserEmailField.addTarget(self, action: #selector(createUserEmailFieldDidChange(_:)), for: .editingChanged)
        createUserEmailField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEndOnExit)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        setUpScrollView()
                
        let stack = UIStackView(arrangedSubviews: [
            UILabel().wrap().withTitle("Get Started"),
            UILabel().wrap().withTitle("To get started using the Embedded SDK sample app, enter your email to begin registering a credential.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            createUserEmailField,
            createUserButton,
            createUserLabel,
            UILabel().wrap().withTitle("If a credential was already registered but the credential has been lost, recover the user instead.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            RecoveryView(recoveryURL: viewModel.recoverUserEndpoint, for: self),
            UILabel().wrap().withTitle("SDK Functionality"),
            UILabel().wrap().withTitle("Explore the various functions available when a credential exists on the device.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            manageCredentialsButton,
            extendCredentialsButton,
            authenticationButton
        ]).vertical()
        
        contentView.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            stack.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stack.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc func createUser() {
        guard let email = createUserEmail, email.contains("@") else {
            createUserLabel.text = "enter an email first"
            return
        }
        signUpAction(email)
    }
    
    func signUpAction(_ email: String) {
        send(for: self, with: createRequest(with: email))
    }
    
    func createRequest(with email: String) -> URLRequest {
        var request = URLRequest(url: viewModel.registrationEndpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "binding_token_delivery_method": "email",
            "external_id" : email,
            "email" : email,
            "user_name" : email,
            "display_name" : email
        ]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        request.httpBody = bodyData
        
        return request
    }
    
    @objc func createUserEmailFieldDidChange(_ textField: UITextField) {
        if let input = textField.text, !input.isEmpty {
            createUserEmail = input
        }
    }
    
    @objc func textFieldDidEnd(_ textField: UITextField) {
        textField.resignFirstResponder()
        createUser()
    }
    
    @objc func toAuthentication() {
        navigationController?.pushViewController(AuthenticationViewController(viewModel: viewModel), animated: true)
    }
    
    @objc func toExtendCredentials() {
        navigationController?.pushViewController(ExtendCredentialsViewController(viewModel: viewModel), animated: true)
    }
    
    @objc func toManageCredentials() {
        navigationController?.pushViewController(ManageCredentialsViewController(viewModel: viewModel), animated: true)
    }
    
}
