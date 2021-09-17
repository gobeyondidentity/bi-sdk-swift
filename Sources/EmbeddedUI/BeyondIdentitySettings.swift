import Foundation
import SharedDesign

/// Config used to create a `BeyondIdentityButton` or `BeyondIdentitySettings`
public struct BeyondIdentityConfig {
    /// Either your support email "mailto:acme@mail.com" or a url to your support page "https://support-page.com
    let supportURL: URL
    
    /// An action that will be called when the user requests to sign up. This could be an action that navigates to your sign up screen.
    let signUpAction: () -> Void
    
    /// An action that will be called when the user requests to recover an account. This could be an action that navigates to your recover screen.
    let recoverUserAction: () -> Void
    
    /// Returns your app name by finding either a localized version of`CFBundleDisplayName`, kCFBundleNameKey or the bundle filename without the .app extension in that order.
    var appName: String {
        return getAppName(for: .main)
    }
    
    /// Initalize a BeyondIdentityConfig to create a `BeyondIdentityButton` or `BeyondIdentitySettings`
    /// - Parameters:
    ///   - supportEmail: Your support email
    ///   - signUpAction: An action that will be called when the user requests to sign up. This could be an action that navigates to your sign up screen.
    ///   - recoverUserAction: An action that will be called when the user requests to recover an account. This could be an action that navigates to your recover screen.
    public init(
        supportURL: URL,
        signUpAction: @escaping () -> Void,
        recoverUserAction: @escaping () -> Void
    ){
        self.supportURL = supportURL
        self.signUpAction = signUpAction
        self.recoverUserAction = recoverUserAction
    }
}

/// Opens the UI for the Beyond Identity Settings
/// - Parameters:
///   - viewController: the viewController presenting the Settings UI
///   - config: structure holding required information and callbacks
public func openBeyondIdentitySettings(
    with viewController: ViewController,
    config: BeyondIdentityConfig
) {
    let settingVC = SettingsViewController(
        config: config
    )
    viewController.present(CustomNavigationController(rootViewController: settingVC), animated: true, completion: nil)
}

/// Returns your app name by finding either a localized version of`CFBundleDisplayName`, kCFBundleNameKey or the bundle filename without the .app extension in that order.
func getAppName(for bundle: Bundle) -> String {
    if let name = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName")
        ?? bundle.object(forInfoDictionaryKey: kCFBundleNameKey as String),
       let stringName = name as? String {
        return stringName
    }
    
    let bundleURL = bundle.bundleURL
    let filename = bundleURL.lastPathComponent
    return stripFileExtension(filename)
}

private func stripFileExtension(_ filename: String ) -> String {
    var components = filename.components(separatedBy: ".")
    guard components.count > 1 else { return filename }
    components.removeLast()
    return components.joined(separator: ".")
}
