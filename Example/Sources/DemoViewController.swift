import UIKit

enum DemoState {
    case Authenticator
    case Embedded
    case EmbeddedUI
}

class DemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "BISDK Demos"
        
        let version = UILabel().wrap().withTitle("Version: \(EmbeddedViewModel().sdkVersion)")

        let authButton = makeButton(with: "Authenticator Demo")
        authButton.addTarget(self, action: #selector(toAuth), for: .touchUpInside)

        let embeddedButton = makeButton(with: "Embedded Demo")
        embeddedButton.addTarget(self, action: #selector(toEmbedded), for: .touchUpInside)
        
        let embeddedUIButton = makeButton(with: "Embedded UI Demo")
        embeddedUIButton.addTarget(self, action: #selector(toEmbeddedUI), for: .touchUpInside)
        
        view.addSubview(version)
        view.addSubview(authButton)
        view.addSubview(embeddedButton)
        view.addSubview(embeddedUIButton)

        version.translatesAutoresizingMaskIntoConstraints = false
        authButton.translatesAutoresizingMaskIntoConstraints = false
        embeddedButton.translatesAutoresizingMaskIntoConstraints = false
        embeddedUIButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            version.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            version.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            authButton.topAnchor.constraint(equalTo: version.bottomAnchor, constant: 10),
            authButton.centerXAnchor.constraint(equalTo: version.centerXAnchor),
            embeddedButton.topAnchor.constraint(equalTo: authButton.bottomAnchor, constant: 10),
            embeddedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            embeddedUIButton.topAnchor.constraint(equalTo: embeddedButton.bottomAnchor, constant: 10),
            embeddedUIButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
