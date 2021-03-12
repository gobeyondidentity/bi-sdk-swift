import AuthenticationServices
import Foundation
import UIKit

public class AuthView: UIView {
    let signInCallBack: (Result<URL,Error>) -> Void
    let signUpAction: () -> Void
    let callbackURLScheme: String
    let redirectURL: URL
    
    public init(redirectURL:URL, callbackURLScheme: String, signInCallBack: @escaping (Result<URL,Error>) -> Void, signUpAction: @escaping () -> Void) {
        self.redirectURL = redirectURL
        self.callbackURLScheme = callbackURLScheme
        self.signInCallBack = signInCallBack
        self.signUpAction = signUpAction
        super.init(frame: .zero)
        setUpViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        let signInButton = SignInButton(title: "Log in with Beyond Identity")
        let signUpButton = SignUpButton(title: "New to Beyond Identity? Go passwordless today")
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
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @objc private func signUp(){
        signUpAction()
    }
    
    @objc private func signIn() {
        let session = ASWebAuthenticationSession(
            url: redirectURL,
            callbackURLScheme: callbackURLScheme) { [weak self] url, error in
            if let error = error { self?.signInCallBack(.failure(error)) }
            if let url = url { self?.signInCallBack(.success(url)) }
        }
        
        if #available(iOS 13.0, *) {
            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = true
        }
        session.start()
    }
}

extension AuthView: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return superview?.window ?? ASPresentationAnchor()
    }
}
