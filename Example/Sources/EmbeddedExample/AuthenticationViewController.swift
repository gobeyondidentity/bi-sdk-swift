import Anchorage
import AuthenticationServices
import BeyondIdentityEmbedded
import os
import SharedDesign
import UIKit

class AuthenticationViewController: ScrollableViewController {
    private let viewModel: EmbeddedViewModel
    private var emailOtpUrl: URL? = nil
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        
        view.backgroundColor = Colors.background.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardObserver()
        hideKeyboardWhenTappedOutside()
        
        let authenticateTitle = UILabel().wrap().withText(Localized.authenticateTitle.string).withFont(Fonts.largeTitle)
        
        let authenticateDetail = UILabel().wrap().withText(Localized.authenticateDetail.string).withFont(Fonts.title2)
        
        let authenticationContextView = Card(
            title: Localized.authGetAuthenticationContext.string,
            detail: Localized.authGetAuthenticationContextText.string,
            cardView: ButtonView(
                buttonTitle: Localized.authGetAuthenticationContext.string
            ){ [weak self] printToScreen in
                guard let self = self else { return }
                guard let (authURLWithPKCE, _) = appendPKCE(for: self.viewModel.beyondIdentityAuth) else {
                    printToScreen("Unable to append PKCE to url: \(self.viewModel.beyondIdentityAuth.absoluteString)")
                    return
                }
                do {
                    let (authData, authJSON) = try await sendRequest(with: createBeyondIdentityAuthRequest(url: authURLWithPKCE))
                    guard let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: authData) else {
                        printToScreen("Not able to parse data: \(authJSON)")
                        return
                    }
                    
                    guard let url = URL(string: authResponse.authenticateURL) else {
                        printToScreen("Not a URL: \(authResponse.authenticateURL)")
                        return
                    }
                    
                    let authenticationContext = try await Embedded.shared.getAuthenticationContext(url: url)
                    
                    printToScreen(authenticationContext.description)
                } catch {
                    printToScreen(error.localizedDescription)
                }
            }
        )
        
        let beyondIdentityView = Card(
            title: Localized.authBeyondIdentity.string,
            detail: Localized.authBeyondIdentityText.string,
            cardView: ButtonView(
                buttonTitle: Localized.authBeyondIdentity.string
            ){ [weak self] printToScreen in
                guard let self = self else { return }
                guard let (authURLWithPKCE, codeVerifier) = appendPKCE(for: self.viewModel.beyondIdentityAuth) else {
                    printToScreen("Unable to append PKCE to url: \(self.viewModel.beyondIdentityAuth.absoluteString)")
                    return
                }
                do {
                    let (authData, authJSON) = try await sendRequest(with: createBeyondIdentityAuthRequest(url: authURLWithPKCE))
                    guard let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: authData) else {
                        printToScreen("Not able to parse data: \(authJSON)")
                        return
                    }
                    
                    guard let url = URL(string: authResponse.authenticateURL) else {
                        printToScreen("Not a URL: \(authResponse.authenticateURL)")
                        return
                    }
                    
                    let response = try await self.authenticate(url: url)
                    guard let code = parseParameter(from: response.redirectUrl, for: "code") else {
                        printToScreen("Unable to parse code from URL:\n \(url)")
                        return
                    }
                    let request = createBeyondIdentityTokenRequest(
                        with: self.viewModel.beyondIdentityToken,
                        code: code,
                        code_verifier: codeVerifier.value
                    )
                    let (tokenData, tokenJSON) = try await sendRequest(with: request)
                    printToScreen(await handleTokenResponse(data: tokenData, json: tokenJSON))
                } catch {
                    printToScreen(error.localizedDescription)
                }
            }
        )
        
        let oktaView = Card(
            title: Localized.authOkta.string,
            detail: Localized.authOktaText.string,
            cardView: ButtonView(
                buttonTitle: Localized.authOkta.string
            ){ [weak self] printToScreen in
                guard let self = self else { return }
                do {
                    let (code, codeVerifier) = try await self.authenticateInnerAndOuter(
                        initialURL: self.viewModel.oktaConfig.generateAuthURL,
                        prefersEphemeralWebBrowserSession: true
                    )
                    
                    let request = createOktaTokenRequest(
                        with: self.viewModel.oktaConfig.tokenBaseURL,
                        code: code,
                        code_verifier: codeVerifier.value
                    )
                    
                    let (data, json) = try await sendRequest(with: request)
                    printToScreen(await handleTokenResponse(data: data, json: json))
                } catch {
                    printToScreen(error.localizedDescription)
                }
            }
        )
        
        let auth0View = Card(
            title: Localized.authAuth0.string,
            detail: Localized.authAuth0Text.string,
            cardView: ButtonView(
                buttonTitle: Localized.authAuth0.string
            ){ [weak self] printToScreen in
                guard let self = self else { return }
                do {
                    let (code, codeVerifier) = try await self.authenticateInnerAndOuter(
                        initialURL: self.viewModel.auth0Config.generateAuthURL,
                        prefersEphemeralWebBrowserSession: false
                    )
                    
                    let request = createAuth0TokenRequest(
                        with: self.viewModel.auth0Config,
                        code: code,
                        code_verifier: codeVerifier.value
                    )
                    
                    let (data, json) = try await sendRequest(with: request)
                    printToScreen(await handleTokenResponse(data: data, json: json))
                } catch {
                    printToScreen(error.localizedDescription)
                }
            }
        )
        
        let customAuthView = Card(
            title: Localized.authenticateCustomTitle.string,
            detail: Localized.authenticateCustomText.string,
            cardView: InputView<URL>(
                buttonTitle: Localized.authenticateTitle.string,
                placeholder: Localized.authenticateURLPlaceholder.string
            ){ [weak self] (url, printToScreen) in
                guard let self = self else { return }
                if Embedded.shared.isAuthenticateUrl(url){
                    do {
                        let response = try await self.authenticate(url: url)
                        printToScreen(response.redirectUrl.absoluteString)
                    } catch {
                        printToScreen(error.localizedDescription)
                    }
                } else {
                    printToScreen("URL provided is not a proper authenticate URL")
                }
            }
        )
        
        let authEmailOtpAuthView = Card(
            title: Localized.emailOtp.string,
            detail: Localized.authEmailOtpText.string,
            cardView: InputView<String>(
                buttonTitle: Localized.emailOtp.string,
                placeholder: Localized.authEmailOtpPlaceholder.string
            ){ [weak self] (email, printToScreen) in
                guard let self = self else { return }
                guard let (authURLWithPKCE, _) = appendPKCE(for: self.viewModel.beyondIdentityAuth) else {
                    printToScreen("Unable to append PKCE to url: \(self.viewModel.beyondIdentityAuth.absoluteString)")
                    return
                }
                do {
                    let (authData, authJSON) = try await sendRequest(with: createBeyondIdentityAuthRequest(url: authURLWithPKCE))
                    guard let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: authData) else {
                        printToScreen("Not able to parse data: \(authJSON)")
                        return
                    }
                    
                    guard let url = URL(string: authResponse.authenticateURL) else {
                        printToScreen("Not a URL: \(authResponse.authenticateURL)")
                        return
                    }
                    
                    do {
                        let response = try await Embedded.shared.authenticateOtp(url: url, email: email)
                        
                        self.emailOtpUrl = response.url;
                        
                        printToScreen(response.description)
                    } catch {
                        printToScreen(error.localizedDescription)
                    }
                } catch {
                    printToScreen(error.localizedDescription)
                }
            }
        )
        
        let redeemEmailOtpAuthView = Card(
            title: Localized.redeemOtp.string,
            detail: Localized.redeemEmailOtpText.string,
            cardView: InputView<String>(
                buttonTitle: Localized.redeemOtp.string,
                placeholder: Localized.redeemEmailOtpPlaceholder.string
            ){ [weak self] (otp, printToScreen) in
                guard let self = self else { return }
                guard let emailOtpUrl = self.emailOtpUrl else {
                    printToScreen("Missing emailOtpUrl")
                    return
                }
                do {
                    let authenticateResponse = try await Embedded.shared.redeemOtp(url: emailOtpUrl, otp: otp)
                    switch authenticateResponse {
                    case let .success(authenticateResponse):
                        printToScreen("otp succeeded:\n \(authenticateResponse)")
                    case let .failedOtp(otpChallengeResponse):
                        printToScreen("otp failed:\n \(otpChallengeResponse)")
                    }
                } catch {
                    printToScreen(error.localizedDescription)
                }
            }
        )
        
        let stack = StackView(arrangedSubviews: [
            authenticateTitle,
            authenticateDetail,
            authenticationContextView,
            beyondIdentityView,
            auth0View,
            oktaView,
            customAuthView,
            authEmailOtpAuthView,
            redeemEmailOtpAuthView
        ]).vertical()
        stack.alignment = .fill
        stack.spacing = Spacing.padding
        
        contentView.addSubview(stack)
        
        stack.verticalAnchors == contentView.safeAreaLayoutGuide.verticalAnchors + Spacing.large
        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + Spacing.large
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func authenticate(url: URL) async throws -> AuthenticateResponse {
        do {
            let passkeys = try await Embedded.shared.getPasskeys()
            guard !passkeys.isEmpty else {
                throw ExampleAppError.description("Passkeys are missing")
            }
            
            if passkeys.count == 1, let id = passkeys.first?.id {
                do {
                    return try await Embedded.shared.authenticate(url: url, id: id)
                } catch {
                    throw error
                }
            }else {
                let id = await self.presentPasskeySelection(passkeys)
                
                guard let id = id else {
                    throw ExampleAppError.description("Selection was canceled")
                }
                
                do {
                    return try await Embedded.shared.authenticate(url: url, id: id)
                } catch {
                    throw error
                }
            }
        } catch {
            throw error
        }
    }
    
    private func authenticateInnerAndOuter(
        initialURL url: URL,
        prefersEphemeralWebBrowserSession: Bool
    ) async throws -> (code: String, codeVerifier: PKCE.CodeVerifier) {
        guard let (pkceURL, codeVerifier) = appendPKCE(
            for: url
        ) else {
            throw ExampleAppError.description("Unable to append PKCE to url: \(url.absoluteString)")
        }
        do {
            let url = try await self.startWebSession(with: pkceURL, prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession)
            let response = try await self.authenticate(url: url)
            let biUrl = try await self.startWebSession(with: response.redirectUrl, prefersEphemeralWebBrowserSession: false)
            guard let code = parseParameter(from: biUrl, for: "code") else {
                throw ExampleAppError.description("Unable to parse code from URL:\n \(biUrl)")
            }
            return (code, codeVerifier)
        } catch {
            throw error
        }
    }
    
    private func presentPasskeySelection(_ passkeys: [Passkey]) async -> Passkey.Id? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                self.presentPasskeySelection(passkeys, continuation.resume)
            }
        }
    }
    
    private func presentPasskeySelection(
        _ passkeys: [Passkey],
        _ completion: @escaping (Passkey.Id?) -> Void
    ) {
        let vc = PasskeyViewController(passkeys: passkeys, completion: completion)
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            if passkeys.count > 3 {
                sheet.detents = [.large()]
            } else {
                sheet.detents = [.medium(), .large()]
            }
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    private func startWebSession(
        with url: URL,
        callbackURLScheme: String = "acme",
        prefersEphemeralWebBrowserSession: Bool
    ) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            startWebSession(
                url: url,
                callbackURLScheme: callbackURLScheme,
                prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession,
                callback: continuation.resume
            )
        }
    }
    
    private func startWebSession(
        url: URL,
        callbackURLScheme: String,
        prefersEphemeralWebBrowserSession: Bool,
        callback: @escaping (Result<URL, Error>) -> Void
    ){
        let session = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: callbackURLScheme
        ){ (url, error) in
            if let error = error {
                if case ASWebAuthenticationSessionError.canceledLogin = error {
                    callback(.failure(BISDKError.description("User canceled")))
                } else {
                    callback(.failure(error))
                }
                return
            }
            guard let url = url else {
                callback(.failure(BISDKError.description("No URL returned")))
                return
            }
            
            // This delay is a workaround to dismiss ASWebAuthenticationSession before presenting the passkey selection viewController
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                callback(.success(url))
            }
        }
        session.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
        session.presentationContextProvider = self
        session.start()
    }
}

extension AuthenticationViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession)
    -> ASPresentationAnchor {
        let window = UIApplication.keyWindow
        return window ?? ASPresentationAnchor()
    }
}

extension UIApplication {
    static var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
        // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
        // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
        // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
        // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
}
