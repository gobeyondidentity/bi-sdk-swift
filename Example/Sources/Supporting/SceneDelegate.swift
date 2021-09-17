import UIKit
import Embedded
import EmbeddedUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        window.rootViewController = UINavigationController(rootViewController: DemoViewController())
        
        self.window = window
        window.makeKeyAndVisible()
        
        if let url = connectionOptions.urlContexts.first?.url {
            register(url)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            register(url)
        }
    }
    
    private func register(_ url: URL){
        guard let demo = UserDefaults.getDemo() else { return }
        
        switch demo {
        case .authenticator:
            break
        case .embedded:
            Embedded.shared.registerCredential(url) { result in
                switch result {
                case let .success(response):
                    print(response)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        case .embeddedUI:
            let vm = EmbeddedViewModel()
            
            let auth = UserDefaults.getClientType()
            
            switch auth {
            case .confidential:
                registerCredentialAndLogin(
                    window: window!,
                    url: url,
                    config: RegisterConfig(
                        authFlowType: .authorize(
                            AuthorizeLoginConfig(
                                clientID: vm.confidentialClientID,
                                redirectURI: vm.redirectURI,
                                pkce: nil,
                                scope: "openid"),
                            { [weak self] authCode in
                                (self?.window?.rootViewController as? UINavigationController)?.pushViewController(
                                    EmbeddedUILoggedInViewController(authResponse: .authorize(authCode)),
                                    animated: true
                                )
                            }),
                        supportURL: vm.supportURL,
                        recoverUserAction: recoverUserAction
                    )
                )
            case .public:
                registerCredentialAndLogin(
                    window: window!,
                    url: url,
                    config: RegisterConfig(
                        authFlowType: .authenticate(
                            AuthenticateLoginConfig(
                                clientID: vm.publicClientID,
                                redirectURI: vm.redirectURI
                            ), { [weak self] tokenResponse in
                                (self?.window?.rootViewController as? UINavigationController)?.pushViewController(
                                    EmbeddedUILoggedInViewController(authResponse: .authenticate(tokenResponse)),
                                    animated: true
                                )
                            }),
                        supportURL: vm.supportURL,
                        recoverUserAction: recoverUserAction
                    )
                )
            }
        }
    }
    
    private func recoverUserAction() {
        let vm = EmbeddedViewModel()
        let currentVC = window?.rootViewController?.presentedViewController ?? window?.rootViewController
        currentVC?.present(RecoverViewController(recoveryURL: vm.recoverUserEndpoint), animated: true, completion: nil)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
}
