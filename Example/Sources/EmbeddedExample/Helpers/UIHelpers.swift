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

extension AuthenticateResponse: CustomStringConvertible {
    public var description: String {
        """
        redirectUrl: \(redirectUrl)
        message: \(message ?? "")
        passkeyBindingToken: \(passkeyBindingToken ?? "")
        """
    }
}

extension Passkey: CustomStringConvertible {
    public var description: String {
        """
        id: \(id.value)
        passkeyId: \(passkeyId.value)
        localCreated: \(localCreated)
        localUpdated: \(localUpdated)
        apiBaseUrl: \(apiBaseUrl)
        keyHandle: \(keyHandle.value)
        state: \(state.rawValue)
        created: \(created)
        updated: \(updated)
        tenant:
        \(tenant.description)
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

extension Tenant: CustomStringConvertible {
    public var description: String {
        """
            id: \(id.value)
            displayName: \(displayName)
        """
    }
}

extension Realm: CustomStringConvertible {
    public var description: String {
        """
            id: \(id.value)
            displayName: \(displayName)
        """
    }
}

extension Identity: CustomStringConvertible {
    public var description: String {
        """
            id: \(id.value)
            displayName: \(displayName)
            username: \(username)
            primaryEmailAddress: \(primaryEmailAddress ?? "")
        """
    }
}

extension Theme: CustomStringConvertible {
    public var description: String {
        """
            logoLightUrl: \(logoLightUrl)
            logoDarkUrl: \(logoDarkUrl)
            supportUrl: \(supportUrl)
        """
    }
}

extension AuthenticationContext {
    public var description: String {
        """
        authUrl: \(authUrl)
        application:
        \(application.description)
        origin:
        \(origin.description)
        """
    }
}

extension AuthenticationContext.Application {
    public var description: String {
        """
            id: \(id.value)
            displayName: \(displayName ?? "")
        """
    }
}

extension AuthenticationContext.Origin {
    public var description: String {
        """
            sourceIp: \(sourceIp ?? "")
            userAgent: \(userAgent ?? "")
            geolocation: \(geolocation ?? "")
            referer: \(referer ?? "")
        """
    }
}

extension OtpChallengeResponse {
    public var description: String {
        """
        url: \(url)
        """
    }
}
