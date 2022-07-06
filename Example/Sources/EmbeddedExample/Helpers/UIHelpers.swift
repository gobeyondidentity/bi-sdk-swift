import Anchorage
import BeyondIdentityEmbedded
import Foundation
import UIKit
import SharedDesign

extension UITextField {
    func with(placeholder: String, type: UIKeyboardType) -> UITextField {
        self.backgroundColor = .white
        self.borderStyle = .roundedRect
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.keyboardType = type
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.lightGray])
        self.textColor = .black
        return self
    }
}

extension UIStackView {
    func vertical() -> UIStackView {
        self.axis = .vertical
        self.spacing = 10
        self.alignment = .leading
        return self
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedOutside() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ScrollableViewController {
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
    
    func addKeyboardObserver(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}

func makeButton(with name: String) -> UIButton {
    let button = UIButton()
    button.setTitle(name, for: .normal)
    button.layer.cornerRadius = 4
    button.setTitleColor(Colors.standardButtonText.value, for: .normal)
    button.layer.backgroundColor = Colors.primary.value.cgColor
    return button
}

func makeCard(title: String, text: String, button: Button, responseLabel: ResponseLabelView) -> View {
    let title = UILabel().wrap().withText(title).withFont(Fonts.title)
    let text =  UILabel().wrap().withText(text).withFont(Fonts.title2)
    
    let stack = UIStackView(arrangedSubviews: [
        title,
        text,
        button,
        responseLabel
    ]).vertical()
    
    stack.alignment = .fill
    stack.spacing = Spacing.large
    return stack
}

extension AuthenticateResponse: CustomStringConvertible {
    public var description: String {
        """
        redirectURL: \(redirectURL)
        message: \(message ?? "")
        """
    }
}

extension Credential: CustomStringConvertible {
    public var description: String {
        """
        id: \(id.value)
        localCreated: \(localCreated)
        localUpdated: \(localUpdated)
        apiBaseURL: \(apiBaseURL)
        tenantID: \(tenantID.value)
        realmID: \(realmID.value)
        identityID: \(identityID.value)
        keyHandle: \(keyHandle.value)
        state: \(state.rawValue)
        created: \(created)
        updated: \(updated)
        realm:
        \(realm.description)
        identity:
        \(identity.description)
        theme:
        \(theme.description)
        \n
        """
    }
}

extension Realm: CustomStringConvertible {
    public var description: String {
        """
            displayName: \(displayName)
        """
    }
}

extension Identity: CustomStringConvertible {
    public var description: String {
        """
            displayName: \(displayName)
            username: \(username)
        """
    }
}

extension Theme: CustomStringConvertible {
    public var description: String {
        """
            logoLightURL: \(logoLightURL)
            logoDarkURL: \(logoDarkURL)
            supportURL: \(supportURL)
        """
    }
}
