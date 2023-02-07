import Anchorage
import AuthenticationServices
import BeyondIdentityEmbedded
import os
import SharedDesign
import UIKit

class AuthenticationViewController: ScrollableViewController {
    private let viewModel: EmbeddedViewModel
    
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
                sendRequest(for: self, with: createBeyondIdentityAuthRequest(url: authURLWithPKCE), onError: printToScreen) { (data, json) in
                    guard let response = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
                        printToScreen("Not able to parse data: \(json)")
                        return
                    }
                    
                    guard let url = URL(string: response.authenticateURL) else {
                        printToScreen("Not a URL: \(response.authenticateURL)")
                        return
                    }
                    
                    self.authenticate(url: url, printToScreen: printToScreen){ result in
                        switch result {
                        case let .success(response):
                            guard let code = parseParameter(from: response.redirectUrl, for: "code") else {
                                printToScreen("Unable to parse code from URL:\n \(url)")
                                return
                            }
                            let request = createBeyondIdentityTokenRequest(
                                with: self.viewModel.beyondIdentityToken,
                                code: code,
                                code_verifier: codeVerifier.value
                            )
                            sendRequest(for: self, with: request, onError: printToScreen) { (data, json) in
                                handleTokenResponse(data: data, json: json, callback: printToScreen)
                            }
                        case let .failure(error):
                            printToScreen(error.localizedDescription)
                        }
                    }
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
                self.authenticateInnerAndOuter(
                    initialURL: self.viewModel.oktaConfig.generateAuthURL,
                    prefersEphemeralWebBrowserSession: true,
                    sendToLabel: printToScreen,
                    makeTokenExchange: { (code, codeVerifier) in
                        let request = createOktaTokenRequest(
                            with: self.viewModel.oktaConfig.tokenBaseURL,
                            code: code,
                            code_verifier: codeVerifier.value
                        )
                        sendRequest(for: self, with: request, onError: printToScreen) { (data, json) in
                            handleTokenResponse(data: data, json: json, callback: printToScreen)
                        }
                    }
                )
            }
        )
        
        let auth0View = Card(
            title: Localized.authAuth0.string,
            detail: Localized.authAuth0Text.string,
            cardView: ButtonView(
                buttonTitle: Localized.authAuth0.string
            ){ [weak self] printToScreen in
                guard let self = self else { return }
                self.authenticateInnerAndOuter(
                    initialURL: self.viewModel.auth0Config.generateAuthURL,
                    prefersEphemeralWebBrowserSession: false,
                    sendToLabel: printToScreen,
                    makeTokenExchange: { (code, codeVerifier) in
                        let request = createAuth0TokenRequest(
                            with: self.viewModel.auth0Config,
                            code: code,
                            code_verifier: codeVerifier.value
                        )
                        sendRequest(for: self, with: request, onError: printToScreen) { (data, json) in
                            handleTokenResponse(data: data, json: json, callback: printToScreen)
                        }
                    }
                )
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
                    self.authenticate(url: url, printToScreen: printToScreen) { result in
                        switch result {
                        case let .success(response):
                            printToScreen(response.redirectUrl.absoluteString)
                        case let .failure(error):
                            printToScreen(error.localizedDescription)
                        }
                    }
                }else {
                    printToScreen("URL provided is not a proper authenticate URL")
                }
            }
        )
        
        let stack = StackView(arrangedSubviews: [
            authenticateTitle,
            authenticateDetail,
            beyondIdentityView,
            auth0View,
            oktaView,
            customAuthView
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
    
    private func authenticate(
        url: URL,
        printToScreen: @escaping(String) -> Void,
        callback: @escaping (Result<AuthenticateResponse, BISDKError>) -> Void
    ){
        Embedded.shared.getPasskeys { result in
            switch result {
            case let .success(passkeys):
                guard !passkeys.isEmpty else {
                    return printToScreen("Passkeys are missing")
                }
                
                if passkeys.count == 1, let id = passkeys.first?.id {
                    Embedded.shared.authenticate(
                        url: url,
                        id: id,
                        callback: callback
                    )
                }else {
                    self.presentPasskeySelection(passkeys) { id in
                        guard let id = id else {
                            print("Selection was canceled")
                            return
                        }
                        Embedded.shared.authenticate(
                            url: url,
                            id: id,
                            callback: callback
                        )
                    }
                }
            case let .failure(error):
                printToScreen(error.localizedDescription)
            }
        }
    }
    
    private func authenticateInnerAndOuter(
        initialURL url: URL,
        prefersEphemeralWebBrowserSession: Bool,
        sendToLabel printToScreen: @escaping (String) -> Void,
        makeTokenExchange: @escaping (_ code: String, _ codeVerifier: PKCE.CodeVerifier) -> Void
    ){
        guard let (pkceURL, codeVerifier) = appendPKCE(
            for: url
        ) else {
            printToScreen("Unable to append PKCE to url: \(url.absoluteString)")
            return
        }
        self.startWebSession(
            with: pkceURL,
            prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession,
            sendToLabel: printToScreen
        ){ [weak self] url in
            guard let self = self else { return }
            self.authenticate(url: url, printToScreen: printToScreen){ result in
                switch result {
                case let .success(response):
                    self.startWebSession(
                        with: response.redirectUrl,
                        prefersEphemeralWebBrowserSession: false,
                        sendToLabel: printToScreen
                    ) { url in
                        guard let code = parseParameter(from: url, for: "code") else {
                            printToScreen("Unable to parse code from URL:\n \(url)")
                            return
                        }
                        makeTokenExchange(code, codeVerifier)
                    }
                case let .failure(error):
                    printToScreen(error.localizedDescription)
                }
            }
        }
    }
    
    private func presentPasskeySelection(
        _ passkeys: [Passkey],
        _ completion: @escaping (Passkey.Id?) -> Void
    ) {
        let vc = PasskeyViewController(passkeys: passkeys, completion: completion)
        vc.modalPresentationStyle = .pageSheet
        
        if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
                if passkeys.count > 3 {
                    sheet.detents = [.large()]
                }else {
                    sheet.detents = [.medium(), .large()]
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    private func startWebSession(
        with url: URL,
        callbackURLScheme: String? = "acme",
        prefersEphemeralWebBrowserSession: Bool,
        sendToLabel callback: @escaping (String) -> Void,
        completion: @escaping (URL) -> Void
    ){
        let session = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: callbackURLScheme
        ){ (url, error) in
            if let error = error {
                if case ASWebAuthenticationSessionError.canceledLogin = error {
                    callback("User canceled")
                }else {
                    callback(error.localizedDescription)
                }
                return
            }
            guard let url = url else {
                callback("No URL returned")
                return
            }
            
            // This delay is a workaround to dismiss ASWebAuthenticationSession before presenting the passkey selection viewController
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(url)
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
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
    }
}
