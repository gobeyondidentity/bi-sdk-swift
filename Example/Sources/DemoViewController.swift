import Anchorage
import UIKit
import SharedDesign

enum DemoState {
    case Authenticator
    case Embedded
    case EmbeddedUI
}

class DemoViewController: ScrollableViewController {

    private let line = Line()

    private let lineTwo = Line()

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

        let beyondIdentityTitle = UILabel().wrap().withTitle(Localized.beyondIdentityTitle.string).withFont(Fonts.largeTitle)
        let beyondIdentityText =  UILabel().wrap().withTitle(Localized.beyondIdentityText.string).withFont(Fonts.title2)
        let embeddedSdkTitle = UILabel().wrap().withTitle(Localized.embeddedSdkTitle.string).withFont(Fonts.navTitle)
        let embeddedSdkText =  UILabel().wrap().withTitle(Localized.embeddedSdkText.string).withFont(Fonts.title2)
        let sdkVersion = UILabel().wrap().withTitle("Version: \(EmbeddedViewModel().sdkVersion)").withFont(Fonts.medium)
        let embeddedUiTitle = UILabel().wrap().withTitle(Localized.embeddedUiTitle.string).withFont(Fonts.navTitle)
        let embeddedUiText = UILabel().wrap().withTitle(Localized.embeddedUiText.string).withFont(Fonts.title2)
        let authenticatorTitle = UILabel().wrap().withTitle(Localized.authenticatorTitle.string).withFont(Fonts.navTitle)
        let authenticatorText = UILabel().wrap().withTitle(Localized.authenticatorText.string).withFont(Fonts.title2)


        let stack = UIStackView(arrangedSubviews: [
            beyondIdentityTitle,
            beyondIdentityText,
            embeddedSdkTitle,
            embeddedSdkText,
            sdkVersion,
            embeddedButton,
            line,
            embeddedUiTitle,
            embeddedUiText,
            embeddedUIButton,
            lineTwo,
            authenticatorTitle,
            authenticatorText,
            authButton,
        ]).vertical()
        
        contentView.addSubview(stack)
        stack.setCustomSpacing(32, after: beyondIdentityText)
        stack.setCustomSpacing(16, after: sdkVersion)
        stack.setCustomSpacing(32, after: embeddedButton)
        stack.setCustomSpacing(32, after: line)
        stack.setCustomSpacing(32, after: embeddedUIButton)
        stack.setCustomSpacing(32, after: lineTwo)
        stack.setCustomSpacing(16, after: authenticatorText)

        stack.horizontalAnchors == contentView.horizontalAnchors + 16
        stack.verticalAnchors == contentView.verticalAnchors + 16
        line.leadingAnchor == stack.leadingAnchor
        line.trailingAnchor == stack.trailingAnchor
        lineTwo.leadingAnchor == stack.leadingAnchor
        lineTwo.trailingAnchor == stack.trailingAnchor
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
