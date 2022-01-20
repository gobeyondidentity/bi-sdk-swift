import BeyondIdentityEmbedded
import UIKit

class RegistrationView: UIView {
    let createUserButton = makeButton(with: "Create User")
    let createUserLabel = UILabel().wrap()
    let createUserEmailField = UITextField().with(placeholder: "Enter email to create a user", type: .emailAddress)
    
    var createUserEmail: String?
    
    let registrationURL: URL
    let viewController: UIViewController
    
    init(registrationURL: URL, for viewController: UIViewController) {
        self.registrationURL = registrationURL
        self.viewController = viewController
        super.init(frame: .zero)
        
        setUpSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubviews() {
        createUserButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        createUserEmailField.addTarget(self, action: #selector(createUserEmailFieldDidChange(_:)), for: .editingChanged)
        createUserEmailField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEndOnExit)
        
        let stack = UIStackView(arrangedSubviews: [
            createUserEmailField,
            createUserButton,
            createUserLabel,
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
    
    @objc func createUser() {
        guard let email = createUserEmail, email.contains("@") else {
            createUserLabel.text = "enter an email first"
            return
        }
        signUpAction(email)
    }
    
    func signUpAction(_ email: String) {
        send(for: viewController, with: createRequest(with: email))
    }
    
    func createRequest(with email: String) -> URLRequest {
        var request = URLRequest(url: registrationURL)
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
}


