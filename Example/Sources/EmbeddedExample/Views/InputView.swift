import Anchorage
import BeyondIdentityEmbedded
import SharedDesign
import UIKit

enum InputViewType {
    case url
    case credentialID
    case string
    case unknown
}

class InputView<T>: UIView {
    let button: Button
    let buttonAction: (T, @escaping (String) -> Void) -> Void
    let inputType: InputViewType
    let label = ResponseLabelView()
    let textField: UITextField
    
    var input: String = ""
    
    /// InputView: UIView
    /// - Parameters:
    ///   - buttonTitle: Button Title
    ///   - placeholder: Input placeholder
    ///   - buttonAction: When button taps, this action will run passing the caller both the input value type and a function that when given a String will print to the label
    init(
        buttonTitle: String,
        placeholder: String,
        buttonAction: @escaping (T, @escaping (String) -> Void) -> Void
    ) {
        let inputType: InputViewType =
        T.self == CredentialID.self ? .credentialID
        : T.self == URL.self ? .url
        : T.self == String.self ? .string
        : .unknown
        button = makeButton(with: buttonTitle)
        textField = UITextField().with(placeholder: placeholder, type: {
            switch inputType {
            case .url:
                return .URL
            case .credentialID:
                return .default
            case .unknown:
                return .default
            case .string:
                return .default
            }
        }())
        self.buttonAction = buttonAction
        self.inputType = inputType
        super.init(frame: .zero)
        setUpSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubviews() {
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        textField.addTarget(self, action: #selector(bindURLFieldDidChange(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEndOnExit)
        
        let stack = UIStackView(arrangedSubviews: [
            textField,
            button,
            label,
        ]).vertical()
        
        addSubview(stack)
        
        stack.horizontalAnchors == horizontalAnchors
        stack.verticalAnchors == verticalAnchors
        stack.alignment = .fill
    }
    
    @objc func onTap() {
        var value: T?
        
        switch inputType {
        case .url:
            guard let url = URL(string: input) as? T else {
                label.text = "Please enter a URL first"
                return
            }
            value = url
        case .credentialID:
            let id = CredentialID(input)
            guard let id = id as? T else {
                label.text = "Please enter a valid credential ID"
                return
            }
            value = id
        case .string:
            if !input.isEmpty, let username = input as? T {
                value = username
            } else {
                label.text = "Please enter a username"
                return
            }
        case .unknown:
            label.text = "Input Type is Unknown"
            return
        }
        
        if let value = value {
            buttonAction(value) { [weak self] text in
                self?.label.text = text
            }
        }
    }
    
    @objc func bindURLFieldDidChange(_ textField: UITextField) {
        if let textInput = textField.text, !textInput.isEmpty {
            input = textInput
        }
    }
    
    @objc func textFieldDidEnd(_ textField: UITextField) {
        textField.resignFirstResponder()
        onTap()
    }
}
