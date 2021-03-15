import UIKit

class InputViewController: UIViewController {
    let textField = UITextField()
    let submitAction: (String) -> Void

    init(_ submitAction: @escaping(String) -> Void) {
        self.submitAction = submitAction
        super.init(nibName: nil, bundle: nil)
        textField.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "Sign Up"
        
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.attributedPlaceholder = NSAttributedString(string: "Enter email", attributes: [.foregroundColor : UIColor.lightGray])
        textField.textColor = .black
        
        view.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
    }
}

extension InputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let input = textField.text, !input.isEmpty {
            submitAction(input)
        }
    }
}
