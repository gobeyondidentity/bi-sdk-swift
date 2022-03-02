import Anchorage
import UIKit

enum DemoState {
    case Authenticator
    case Embedded
    case EmbeddedUI
}

class DemoViewController: ScrollableViewController {

    lazy var customLineSdk: CustomUiLine = {
        let line = CustomUiLine()
        return line
    }()

    lazy var customLineUI: CustomUiLine = {
        let line = CustomUiLine()
        return line
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let imageView = UIImageView(image: .vector)
        navigationItem.titleView = imageView

        let authButton = makeButton(with: Localized.authButton.string)
        authButton.addTarget(self, action: #selector(toAuth), for: .touchUpInside)

        let embeddedButton = makeButton(with: Localized.embeddedButton.string)
        embeddedButton.addTarget(self, action: #selector(toEmbedded), for: .touchUpInside)
        
        let embeddedUIButton = makeButton(with: Localized.embeddedUIButton.string)
        embeddedUIButton.addTarget(self, action: #selector(toEmbeddedUI), for: .touchUpInside)

        let beyondIdentityTitle = UILabel().wrap().withTitle(Localized.beyondIdentityTitle.string).withFont(UIFont(name: OverpassFontNames.bold.rawValue, size: Size.largeTitle) ??  UIFont.systemFont(ofSize: Size.largeTitle))
        let beyondIdentityText =  UILabel().wrap().withTitle(Localized.beyondIdentityText.string).withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))
        let embeddedSdkTitle = UILabel().wrap().withTitle(Localized.embeddedSdkTitle.string).withFont(UIFont(name: OverpassFontNames.bold.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))
        let embeddedSdkText =  UILabel().wrap().withTitle(Localized.embeddedSdkText.string).withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))
        let sdkVersion = UILabel().wrap().withTitle("Version: \(EmbeddedViewModel().sdkVersion)").withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.medium) ??  UIFont.systemFont(ofSize: Size.medium))
        let embeddedUiTitle = UILabel().wrap().withTitle(Localized.embeddedUiTitle.string).withFont(UIFont(name: OverpassFontNames.bold.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))
        let embeddedUiText = UILabel().wrap().withTitle(Localized.embeddedUiText.string).withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))
        let authenticatorTitle = UILabel().wrap().withTitle(Localized.authenticatorTitle.string).withFont(UIFont(name: OverpassFontNames.bold.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))
        let authenticatorText = UILabel().wrap().withTitle(Localized.authenticatorText.string).withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))


        let stack = UIStackView(arrangedSubviews: [
            beyondIdentityTitle,
            beyondIdentityText,
            embeddedSdkTitle,
            embeddedSdkText,
            sdkVersion,
            embeddedButton,
            customLineSdk,
            embeddedUiTitle,
            embeddedUiText,
            embeddedUIButton,
            customLineUI,
            authenticatorTitle,
            authenticatorText,
            authButton,
        ]).vertical()
        
        contentView.addSubview(stack)
        stack.setCustomSpacing(32, after: beyondIdentityText)
        stack.setCustomSpacing(16, after: sdkVersion)
        stack.setCustomSpacing(32, after: embeddedButton)
        stack.setCustomSpacing(32, after: customLineSdk)
        stack.setCustomSpacing(32, after: embeddedUIButton)
        stack.setCustomSpacing(32, after: customLineUI)
        stack.setCustomSpacing(16, after: authenticatorText)

        stack.horizontalAnchors == contentView.horizontalAnchors + 16
        stack.verticalAnchors == contentView.verticalAnchors + 16
        customLineSdk.leadingAnchor == stack.leadingAnchor
        customLineSdk.trailingAnchor == stack.trailingAnchor
        customLineUI.leadingAnchor == stack.leadingAnchor
        customLineUI.trailingAnchor == stack.trailingAnchor
    }

    @objc func toAuth() {
        UserDefaults.set(.authenticator)
        navigationController?.pushViewController(
            PreLoggedInViewController(viewModel: PreLoggedInViewModel()), animated: true)
    }

    @objc func toEmbedded() {
        UserDefaults.set(.embedded)
        navigationController?.pushViewController(
            EmbeddedViewController(viewModel: EmbeddedViewModel()), animated: true)
    }
    
    @objc func toEmbeddedUI() {
        UserDefaults.set(.embeddedUI)
        navigationController?.pushViewController(
            EmbeddedUIViewController(viewModel: EmbeddedViewModel()), animated: true)
    }
}
