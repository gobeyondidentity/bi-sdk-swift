import Anchorage
import UIKit

enum DemoState {
    case Authenticator
    case Embedded
    case EmbeddedUI
}

class DemoViewController: ScrollableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "Beyond Identity SDK Demos"
        
        let authButton = makeButton(with: "Authenticator Demo")
        authButton.addTarget(self, action: #selector(toAuth), for: .touchUpInside)

        let embeddedButton = makeButton(with: "Embedded Demo")
        embeddedButton.addTarget(self, action: #selector(toEmbedded), for: .touchUpInside)
        
        let embeddedUIButton = makeButton(with: "Embedded UI Demo")
        embeddedUIButton.addTarget(self, action: #selector(toEmbeddedUI), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [
            UILabel().wrap().withTitle("Beyond Identity Swift SDKs"),
            UILabel().wrap().withTitle("Version: \(EmbeddedViewModel().sdkVersion)").withFont(UIFont.preferredFont(forTextStyle: .caption1)),

            UILabel().wrap().withTitle("Beyond Identity provides the strongest authentication on the planet, eliminating passwords completely for customers, as well as from your database.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            UILabel().wrap().withTitle("Embedded SDK"),
            UILabel().wrap().withTitle("The Embedded SDK is a holistic SDK solution offering the entire Passwordless authentication embedded into your app. A set of functions are provided to you through the Embedded SDK. This SDK supports OIDC and OAuth2").withFont(UIFont.preferredFont(forTextStyle: .body)),
            embeddedButton,
            UILabel().wrap().withTitle("Embedded UI SDK"),
            UILabel().wrap().withTitle("The Embedded UI SDK provides view wrappers around the Embedded SDK functions.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            embeddedUIButton,
            UILabel().wrap().withTitle("Authenticator SDK"),
            UILabel().wrap().withTitle("Embed Passwordless authentication into your app with the support of the Beyond Identity Authenticator. Users will need to download the Beyond Identity Authenticator.").withFont(UIFont.preferredFont(forTextStyle: .body)),
            authButton,
        ]).vertical()
        
        contentView.addSubview(stack)

        stack.horizontalAnchors == contentView.horizontalAnchors + 16
        stack.verticalAnchors == contentView.verticalAnchors + 16
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
