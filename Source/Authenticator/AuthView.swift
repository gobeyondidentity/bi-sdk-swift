import AuthenticationServices
import Foundation
import UIKit
/**
A two button view that manages a passwordless experience with Beyond Identity.

- Parameters:
  - session: An [ASWebAuthenticationSession](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession) instance used on Sign In.
  - signUpAction: A function called when the user taps the Sign Up button.

Configure an [ASWebAuthenticationSession](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession) instance to authenticate a user.
 
Initialize the session with a URL that points to the authentication webpage that you have configured in your cloud. A secure, embedded web view loads and displays the page, from which the user can authenticate.
 
On completion, the service sends a callback URL to the session with an authentication token, and the session passes this URL back to the app through a completion handler. Use a [Universal Link](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html) for the `callbackURLScheme` as there are potential risks using a Custom URL Scheme. See the warning below.

When the user taps the "Sign In" button, your session will start. When the user taps "Sign Up" button the AuthView will trigger your sign up action.
 
Your sign up action should include a call to the Beyond Identity API to create a user credential as well as a way for the user to [download the Beyond Identity app](https://app.byndid.com/downloads) to store the credential associated with your app.

For more details, see the [Developer Docs](https://docs.byndid.com).
 
- Warning:
Custom URL Schemes offer a potential attack as iOS allows any URL Scheme to be claimed by multiple apps and thus malicious apps can hijack sensitive data.
 
To mitigate this risk, use a [Universal Link](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html) in your production app.

- Author: [Beyond Identity](https://www.beyondidentity.com)
*/

public class AuthView: UIView {
    let session: ASWebAuthenticationSession
    let signUpAction: () -> Void
    let signInButton = SignInButton(title: LocalizedString.value(for: .signInButtonTitle))
    let signUpButton = SignUpButton(title: LocalizedString.value(for: .signUpButtonTitle))

    public init(
        session: ASWebAuthenticationSession,
        signUpAction: @escaping () -> Void) {
        self.session = session
        self.signUpAction = signUpAction
        super.init(frame: .zero)
        setUpViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [signInButton, signUpButton])
        stackView.spacing = 10
        stackView.axis = .vertical
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func signUp() {
        signUpAction()
    }

    @objc private func signIn() {
        if #available(iOS 13.0, *) {
            session.presentationContextProvider = self
        }
        session.start()
    }
}

extension AuthView: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        superview?.window ?? ASPresentationAnchor()
    }
}
