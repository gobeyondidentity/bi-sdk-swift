import AuthenticationServices
import Foundation
import UIKit

public class AuthView: UIView {
    let session: ASWebAuthenticationSession
    let signUpAction: () -> Void
    let signInButton = SignInButton(title: "Log in with Beyond Identity")
    let signUpButton = SignUpButton(title: "New to Beyond Identity? Go passwordless today")
    
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
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @objc private func signUp(){
        signUpAction()
    }
    
    @objc private func signIn() {
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
