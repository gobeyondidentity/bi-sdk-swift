import BeyondIdentityEmbedded
import os
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            let window = UIWindow(windowScene: windowScene)
            
            window.rootViewController = UINavigationController(rootViewController: DemoViewController())
            UINavigationBar.appearance().tintColor = .systemBlue
            
            self.window = window
            window.makeKeyAndVisible()
            
            let viewModel = EmbeddedViewModel()
            
            Embedded.initialize(
                biometricAskPrompt: viewModel.biometricAskPrompt,
                logger: logger
            ) { _ in }
            
            if let url = connectionOptions.urlContexts.first?.url {
                register(url)
            }
        }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            register(url)
        }
    }
    
    func logger(type: OSLogType, message: String) {
        print(message)
    }
    
    private func register(_ url: URL){
        Embedded.shared.bindPasskey(url: url) { [weak self] result in
            switch result {
            case let .success(response):
                let dialog = UIAlertController(title: "Registered passkey: \(response.passkey.identity.displayName)", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                dialog.addAction(action)
                self?.window?.rootViewController?.present(dialog, animated: true, completion: nil)
            case let .failure(error):
                let dialog = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                dialog.addAction(action)
                self?.window?.rootViewController?.present(dialog, animated: true, completion: nil)
            }
        }
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
