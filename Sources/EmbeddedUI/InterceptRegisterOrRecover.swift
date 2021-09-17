import SharedDesign
#if os(iOS)
import UIKit

/// Config used to register or recover a user
public struct RegisterConfig {
    /// Your app's authentication flow
    let authFlowType: FlowType
    
    /// An action that will be called when the user requests to recover an account. This could be an action that navigates to your recover screen.
    let recoverUserAction: () -> Void
    
    /// Either your support email "mailto:acme@mail.com" or a url to your support page "https://support-page.com
    let supportURL: URL
    
    /// Returns your app name by finding either a localized version of`CFBundleDisplayName`, kCFBundleNameKey or the bundle filename without the .app extension in that order.
    var appName: String {
        return getAppName(for: .main)
    }
    
    /// Initialize a RegisterConfig
    /// - Parameters:
    ///   - authFlowType: Your app's authentication flow
    ///   - supportEmail: Your support email
    ///   - recoverUserAction: An action that will be called when the user requests to recover an account. This could be an action that navigates to your recover screen.
    public init(
        authFlowType: FlowType,
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
    let currentVC = window.rootViewController?.presentedViewController ?? window.rootViewController
    currentVC?.present(vc, animated: true, completion: nil)
}
#endif
