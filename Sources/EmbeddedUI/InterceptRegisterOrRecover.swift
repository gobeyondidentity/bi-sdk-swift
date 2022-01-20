import SharedDesign
#if os(iOS)
import UIKit

/// Config used to register or recover a user
public struct RegisterConfig {
    
    /// Returns your app name by finding either a localized version of`CFBundleDisplayName`, kCFBundleNameKey or the bundle filename without the .app extension in that order.
    var appName: String {
        return getAppName(for: .main)
    }
    let authFlowType: AuthFlowType
    let supportURL: URL
    let recoverUserAction: () -> Void
    
    /// Initialize a RegisterConfig
    /// - Parameters:
    ///   - authFlowType: Your app's authentication flow
    ///   - supportURL: Either your support email "mailto:acme@mail.com" or a url to your support page "https://support-page.com
    ///   - recoverUserAction: An action that will be called when the user requests to recover an account. This could be an action that navigates to your recover screen.
    public init(
        authFlowType: AuthFlowType,
        supportURL: URL,
        recoverUserAction: @escaping () -> Void
    ){
        self.authFlowType = authFlowType
        self.recoverUserAction = recoverUserAction
        self.supportURL = supportURL
    }
}


/// Call this function after intercepting a registration or recovery redirect to you app. This is called from your AppDelegate or SceneDelegate.
/// - Parameters:
///   - window: your app's window
///   - url: URL that was intercepted
///   - config: structure holding required information and a callback
public func registerCredentialAndLogin(window: UIWindow, url: URL, config: RegisterConfig){
    let vc = LoadingViewController(
        for: .registerOrRecover(url, config.authFlowType),
           appName: config.appName,
           supportURL: config.supportURL,
           recoverUserAction: config.recoverUserAction
    )
    window.topMostViewController()?.present(vc, animated: true, completion: nil)
}
#endif

extension UIWindow {
    func topMostViewController() -> UIViewController? {
        guard let root = self.rootViewController else {
            return nil
        }
        
        return UIWindow.getTopMostViewController(root)
    }
    
    private static func getTopMostViewController(_ vc: UIViewController) -> UIViewController {
        if let visibleController = (vc as? UINavigationController)?.visibleViewController {
            return UIWindow.getTopMostViewController(visibleController)
        } else if let selectedTabController = (vc as? UITabBarController)?.selectedViewController {
            return UIWindow.getTopMostViewController(selectedTabController)
        } else if let presentedViewController = vc.presentedViewController {
            return UIWindow.getTopMostViewController(presentedViewController)
        } else {
            return vc
        }
    }
}
