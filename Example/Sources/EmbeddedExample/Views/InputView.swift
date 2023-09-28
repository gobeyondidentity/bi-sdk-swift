import Anchorage
import BeyondIdentityEmbedded
import SharedDesign
import UIKit

enum InputViewType {
    case url
    case passkeyID
    case string
    case unknown
}

class InputView<T>: UIView {
    let button: Button
    let buttonAction: (T, @escaping (String) -> Void) async -> Void
    let inputType: InputViewType
    let label: ResponseLabelView
    let textField: UITextField
    
    var input: String = ""
    
    /// InputView: UIView
    /// - Parameters:
    ///   - buttonTitle: Button Title
    ///   - placeholder: Input placeholder
    ///   - buttonAction: When button taps, this action will run passing the caller both the input value and a function that when given a String will print to the label
    init(
        buttonTitle: String,
        placeholder: String,
        buttonAction: @escaping (T, @escaping (String) -> Void) async -> Void
    ) {
        let inputType: InputViewType =
        T.self == Passkey.Id.self ? .passkeyID
        : T.self == URL.self ? .url
        : T.self == String.self ? .string
        : .unknown
        button = makeButton(with: buttonTitle)
        label = ResponseLabelView(buttonTitle)
        textField = UITextField().with(placeholder: placeholder, type: {
            switch inputType {
            case .url:
                return .URL
            case .passkeyID:
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
        label.isLoading = true
        label.resetLabel()
        
        switch inputType {
        case .url:
            guard let url = URL(string: input) as? T else {
                label.text = "Please enter a URL first"
                label.isLoading = false
                return
            }
            value = url
        case .passkeyID:
            guard !input.isEmpty else {
                label.text = "Please enter a passkey ID"
                label.isLoading = false
                return
            }
            let id = Passkey.Id(input)
            guard let id = id as? T else {
                label.text = "Please enter a valid passkey ID"
                label.isLoading = false
                return
            }
            value = id
        case .string:
            if !input.isEmpty, let username = input as? T {
                value = username
            } else {
                label.text = "Please enter a username"
                label.isLoading = false
                return
            }
        case .unknown:
            label.text = "Input Type is Unknown"
            label.isLoading = false
            return
        }
        
        if let value = value {
            Task {
                await buttonAction(value) { [weak self] text in
                    self?.label.text = text
                    self?.label.isLoading = false
                }
            }
        }
    }
    
    @objc func bindURLFieldDidChange(_ textField: UITextField) {
        if let textInput = textField.text, !textInput.isEmpty {
            input = textInput
        }
    }
    
    @objc func textFieldDidEnd(_ textField: UITextField) async {
        _ = textField.resignFirstResponder()
        onTap()
    }
}
