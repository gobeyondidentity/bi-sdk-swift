import Embedded
import UIKit

class RecoveryView: UIView {
    let recoverUserButton = makeButton(with: "Recover User")
    let recoverUserLabel = UILabel().wrap()
    let recoverUserEmailField = UITextField().with(placeholder: "Enter email to recover a user", type: .emailAddress)
    
    var recoverUserEmail: String?
    
    let recoveryURL: URL
    let viewController: UIViewController
    
    init(recoveryURL: URL, for viewController: UIViewController) {
        self.recoveryURL = recoveryURL
        self.viewController = viewController
        super.init(frame: .zero)
        
        setUpSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubviews() {
        recoverUserButton.addTarget(self, action: #selector(recoverUser), for: .touchUpInside)
        
        recoverUserEmailField.addTarget(self,
                                        action: #selector(recoverUserEmailFieldDidChange(_:)),
                                        for: .editingChanged)
        recoverUserEmailField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEndOnExit)
        
        let stack = UIStackView(arrangedSubviews: [
            UILabel().wrap().withTitle("Recovery"),
            recoverUserEmailField,
            recoverUserButton,
            recoverUserLabel,
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
    
    @objc func recoverUser() {
        guard let email = recoverUserEmail, email.contains("@") else {
            recoverUserLabel.text = "enter an email first"
            return
        }
        recoverUserAction(email)
    }
    
    func recoverUserAction(_ email: String){
        send(for: viewController, with: createRequest(with: email))
    }
    
    func createRequest(with email: String) -> URLRequest {
        var request = URLRequest(url: recoveryURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "binding_token_delivery_method": "email",
            "external_id" : email
        ]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        request.httpBody = bodyData
        
        return request
    }
    
    @objc func recoverUserEmailFieldDidChange(_ textField: UITextField) {
        if let input = textField.text, !input.isEmpty {
            recoverUserEmail = input
        }
    }
    
    @objc func textFieldDidEnd(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}

func send(for vc: UIViewController, with request: URLRequest) {
    let webTask = URLSession.shared.dataTask(
        with: request,
        completionHandler: { (data, response, error) in
            var message: String
            
            if let error = error {
                message = error.localizedDescription
            } else if response == nil {
                message = "Error: response is nil"
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 200 {
                message = "Error: got status code \(statusCode)"
            } else if let _ = data {
                message = "check your email!"
            } else {
                message = "Error: missing data"
            }
            
            DispatchQueue.main.async {
                let dialog = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                dialog.addAction(action)
                vc.present(dialog, animated: true, completion: nil)
            }
        })
    
    webTask.resume()
}
