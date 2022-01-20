import Foundation
import SharedDesign

/// Opens the UI for the Beyond Identity Settings. Must be in a logged in state.
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
