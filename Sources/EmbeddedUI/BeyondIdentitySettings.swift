import Foundation
import SharedDesign

/// Config used to create a `BeyondIdentityButton` or `BeyondIdentitySettings`
public struct BeyondIdentityConfig {
    
    /// Returns your app name by finding either a localized version of`CFBundleDisplayName`, kCFBundleNameKey or the bundle filename without the .app extension in that order.
    var appName: String {
        return getAppName(for: .main)
    }
    let supportURL: URL
    let signUpAction: () -> Void
    let recoverUserAction: () -> Void
    
    /// Initalize a BeyondIdentityConfig to create a `BeyondIdentityButton` or `BeyondIdentitySettings`
    /// - Parameters:
    ///   - supportURL: Either your support email "mailto:acme@mail.com" or a url to your support page "https://support-page.com
    ///   - signUpAction: An action that will be called when the user requests to sign up. This could be an action that navigates to your sign up screen.
    ///   - recoverUserAction: An action that will be called when the user requests to recover an account. This could be an action that navigates to your recover screen.
    public init(
        supportURL: URL,
        signUpAction: @escaping () -> Void,
        recoverUserAction: @escaping () -> Void
    ){
        self.recoverUserAction = recoverUserAction
        self.signUpAction = signUpAction
        self.supportURL = supportURL
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
