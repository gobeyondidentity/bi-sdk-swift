import Anchorage
import BeyondIdentityEmbedded
import SharedDesign

#if os(iOS)
import UIKit

class LoadingViewController: ViewController {
    enum ActionType {
        case login(FlowType)
        case registerOrRecover(URL, FlowType)
        case importCredential(FlowType)
        case importCredentialWithoutAuth
    }
    
    let actionType: ActionType
    let appName: String
    let recoverUserAction: () -> Void
    let supportURL: URL
    
    let loadingView = LoadingView()
    let visitSupportLabel = Button()
    let recoverAccountLabel = Button()
    
    init(
        for actionType: ActionType,
        appName: String,
        supportURL: URL,
        recoverUserAction: @escaping () -> Void
    ) {
        self.actionType = actionType
        self.appName = appName
        self.recoverUserAction = recoverUserAction
        self.supportURL = supportURL
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialLoadingViewMessage()
        handleAction()
        
        view.backgroundColor = Colors.background.value
        
        recoverAccountLabel.setTappableText(text: LocalizedString.alternateOptionsRecoverAccountText.string, tappableText: LocalizedString.alternateOptionsRecoverAccountTappableText.string)
        recoverAccountLabel.addTarget(self, action: #selector(tappedRecoverAccount), for: .touchUpInside)
        recoverAccountLabel.isHidden = true
        
        visitSupportLabel.setTappableText(text: LocalizedString.alternateOptionsVisitSupportText.string, tappableText: LocalizedString.alternateOptionsVisitSupportTappableText.string)
        visitSupportLabel.addTarget(self, action: #selector(tappedVisitSupport), for: .touchUpInside)
        
        visitSupportLabel.isHidden = true
        
        let poweredByBILogo = ImageView(image: .poweredByBILogo)
        poweredByBILogo.contentMode = .scaleAspectFit
        poweredByBILogo.setImageColor(color: Colors.body.value)
        
        let stack = StackView(arrangedSubviews: [loadingView, recoverAccountLabel, visitSupportLabel, poweredByBILogo])
        stack.axis = .vertical
        stack.setCustomSpacing(Spacing.large, after: loadingView)
        stack.setCustomSpacing(Spacing.padding, after: visitSupportLabel)
        
        view.addSubview(stack)
        
        stack.topAnchor == view.safeAreaLayoutGuide.topAnchor + Spacing.offsetFromTop(view)
        stack.bottomAnchor <= view.safeAreaLayoutGuide.bottomAnchor
        stack.horizontalAnchors == view.horizontalAnchors + Spacing.padding
    }
    
    func setInitialLoadingViewMessage(){
        switch actionType {
        case .login:
            loadingView.setMessage(LocalizedString.loadingLoginInitialMessage.format(appName))
        case .registerOrRecover:
            loadingView.setMessage(LocalizedString.loadingRecoverOrRegisterInitialMessage.format(appName))
        case .importCredential:
            loadingView.setMessage(LocalizedString.loadingRecoverOrRegisterInitialMessage.format(appName))
        case .importCredentialWithoutAuth:
            loadingView.setMessage(LocalizedString.loadingRecoverOrRegisterInitialMessage.format(appName))
        }
    }
    
    func handleAction(){
        switch actionType {
        case let .login(authType):
            handleAuth(authType)
        case let .registerOrRecover(url, authType):
            Embedded.shared.registerCredential(url){ [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success:
                    self.loadingView.setMessage(LocalizedString.loadingRegisterSuccess.format(self.appName))
                    self.handleAuth(authType)
                case .failure:
                    self.handleError(
                        with: LocalizedString.loadingRegisterError.string,
                        info: LocalizedString.loadingRegisterErrorInfo.string
                    )
                }
            }
        case let .importCredential(authType):
            handleAuth(authType)
        case .importCredentialWithoutAuth:
            let confirmationVC = AddCredentialSuccessViewController(appName: appName)
            navigationController?.pushViewController(confirmationVC, animated: true)
        }
    }
    
    func handleError(with message: String, info: String){
        visitSupportLabel.isHidden = false
        recoverAccountLabel.isHidden = false
        loadingView.setError(message, info)
    }
    
    func handleAuth(_ authType: FlowType){
        switch authType {
        case let .authorize(config, completion):
            authorize(config, completion)
        case let .authenticate(config, completion):
            authenticate(config, completion)
        }
    }
    
    private func authorize(_ config: AuthorizeLoginConfig, _ completion: @escaping (AuthorizationCode) -> Void){
        Embedded.shared.authorize(
            clientID: config.clientID,
            pkceChallenge: config.pkce,
            redirectURI: config.redirectURI,
            scope: config.scope
        ){ [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(authorizationCode):
                self.dismissAllPreviousCustomViewContollers(completion: {
                    completion(authorizationCode)
                })
            case .failure:
                self.handleError(
                    with: LocalizedString.loadingAuthenticationError.string,
                    info: LocalizedString.loadingAuthenticationErrorInfo.string
                )
            }
        }
    }
    
    private func authenticate(_ config: AuthenticateLoginConfig, _ completion: @escaping (TokenResponse) -> Void){
        Embedded.shared.authenticate(clientID: config.clientID, redirectURI: config.redirectURI){ [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(tokenResponse):
                self.dismissAllPreviousCustomViewContollers(completion: {
                    completion(tokenResponse)
                })
            case .failure:
                self.handleError(
                    with: LocalizedString.loadingAuthenticationError.string,
                    info: LocalizedString.loadingAuthenticationErrorInfo.string
                )
            }
        }
    }
    
    @objc func tappedRecoverAccount(){
        navigationController?.dismiss(animated: true, completion: { [weak self] in
            self?.recoverUserAction()
        })
    }
    
    @objc func tappedVisitSupport(){
        openSupport(url: supportURL)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
