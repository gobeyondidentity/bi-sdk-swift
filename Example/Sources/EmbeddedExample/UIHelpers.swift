import Embedded
import Foundation
import UIKit

extension UILabel {
    func wrap() -> UILabel {
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        return self
    }
    
    func withTitle(_ text: String) -> UILabel {
        self.text = text
        font = UIFont.preferredFont(forTextStyle: .title1)
        adjustsFontForContentSizeCategory = true
        return self
    }
}

extension UITextField {
    func with(placeholder: String, type: UIKeyboardType) -> UITextField {
        self.keyboardType = .emailAddress
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

func makeButton(with name: String) -> UIButton {
    let button = UIButton()
    button.setTitle(name, for: .normal)
    button.setTitleColor(.blue, for: .normal)
    return button
}

extension User: CustomStringConvertible {
    public var description: String {
        """
        You will recieve an email shortly!

        internalID: \(internalID)\n
        externalID: \(externalID)\n
        email: \(email)\n
        userName: \(userName)\n
        displayName: \(displayName)\n
        dateCreated: \(dateCreated)\n
        dateModified: \(dateModified)\n
        status: \(status)\n
        """
    }
}

extension PKCE: CustomStringConvertible {
    public var description: String {
        """
        codeVerifier:
        \(codeVerifier)\n
        codeChallenge:
        \(codeChallenge.challenge)\n
        method: \(codeChallenge.method)\n
        """
    }
}

extension Credential: CustomStringConvertible {
    public var description: String {
        """
        created: \(created)
        handle: \(handle.value)
        keyHandle: \(keyHandle)
        name: \(name)
        logoURL: \(logoURL)
        loginURI: \(loginURI ?? "no loginURI available")
        enrollURI: \(enrollURI ?? "no enrollURI available")
        chain:
        \(chain)\n
        rootFingerprint: \(rootFingerprint)
        """
    }
}

extension AccessToken: CustomStringConvertible {
    public var description: String {
        """
        value: \(value)\n
        tokenType: \(type)\n
        expiresIn: \(expiresIn)\n
        """
    }
}

extension TokenResponse: CustomStringConvertible {
    public var description: String {
        """
        accessToken: \(accessToken.description)\n
        idToken: \(idToken)\n
        """
    }
}
