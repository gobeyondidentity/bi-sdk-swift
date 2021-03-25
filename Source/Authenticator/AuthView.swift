import AuthenticationServices
import Foundation
import UIKit
/**
A two button view that manages a passwordless experience with Beyond Identity.

 Parameters:
 - url: A URL with the http or https scheme pointing to the authentication webpage.
 - callbackURLScheme: The custom URL scheme that the app expects in the callback URL.
 - completionHandler: A completion handler the session calls when it completes successfully, or when the user cancels the session.
 - prefersEphemeralWebBrowserSession: A Boolean value that indicates whether the session should ask the browser for a private authentication session.
 - signUpAction: A function called when the user taps the Sign Up button.

An `AuthView` handles creating and starting an [ASWebAuthenticationSession](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession) instance to authenticate a user.
 
Initialize an `AuthView` session with a `url` that either points to the authentication webpage that you have configured in your cloud or make a call to Beyond Identity's `/authorize` endpoint to get an authorization code. A secure, embedded web view loads and displays the page, from which the user can authenticate.
 
If your backend is getting the authorization code and exchanging the access token, then on completion, the service sends a callback `url` to the session with anything your backend is configured to send.

If your client is getting the authorization code, then on completion, the service sends a callback `url` to the session with an authorization code that you can then send to your backend to make a token exchange.

When the user taps the "Sign In" button, your session will start. When the user taps "Sign Up" button the AuthView will trigger your sign up action.
 
Your sign up action should include a call to the Beyond Identity API to create a user credential as well as a way for the user to [download the Beyond Identity app](https://app.byndid.com/downloads) to store the credential associated with your app.

For more details, see the [Developer Docs](https://docs.byndid.com).
 
- Warning:
Custom URL Schemes offer a potential attack as iOS allows any URL Scheme to be claimed by multiple apps and thus malicious apps can hijack sensitive data.
 
To mitigate this risk, use a [Universal Link](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html) in your production app.

- Author: [Beyond Identity](https://www.beyondidentity.com)
*/

public class AuthView: UIView {
    // ASWebAuthenticationSession
    let url: URL
    let callbackURLScheme: String?
    let completionHandler: ASWebAuthenticationSession.CompletionHandler
    let prefersEphemeralWebBrowserSession: Bool

    // Beyond Identity
    let signUpAction: () -> Void
    let signInButton = SignInButton(title: LocalizedString.value(for: .signInButtonTitle))
    let signUpButton = SignUpButton(title: LocalizedString.value(for: .signUpButtonTitle))

    public init(
        url: URL,
        callbackURLScheme: String?,
        completionHandler: @escaping ASWebAuthenticationSession.CompletionHandler,
        prefersEphemeralWebBrowserSession: Bool = false,
        signUpAction: @escaping () -> Void) {
        self.url = url
        self.callbackURLScheme = callbackURLScheme
        self.completionHandler = completionHandler
        self.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
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
        // `start` only called once per session, create a new session to retry
        let session = createSession(
            url: url,
            callbackURLScheme: callbackURLScheme,
            completionHandler: completionHandler
        )

        startSession(session)
    }

    func createSession(
        url: URL,
        callbackURLScheme: String?,
        completionHandler: @escaping ASWebAuthenticationSession.CompletionHandler,
        prefersEphemeralWebBrowserSession: Bool = false
    ) -> ASWebAuthenticationSession {
        let session = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: callbackURLScheme,
            completionHandler: completionHandler
        )
        if #available(iOS 13.0, *) {
            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
        }

        return session
    }

    func startSession(_ session: ASWebAuthenticationSession) {
        session.start()
    }
}

extension AuthView: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        superview?.window ?? ASPresentationAnchor()
    }
}
