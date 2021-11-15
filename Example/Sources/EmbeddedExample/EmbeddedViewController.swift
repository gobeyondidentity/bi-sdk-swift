import BeyondIdentityEmbedded
import UIKit

class EmbeddedViewController: ScrollableViewController {
    let viewModel: EmbeddedViewModel
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "Embedded Demo"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        setUpScrollView()
        
        let infoLabel = UILabel().wrap()
        infoLabel.text = "The following functions are provided to you through the `Embedded` namespace."
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        let stack = UIStackView(arrangedSubviews: [
            infoLabel,
            CredentialsView(viewModel: viewModel),
            RegistrationView(registrationURL: viewModel.registrationEndpoint, for: self),
            RecoveryView(recoveryURL: viewModel.recoverUserEndpoint, for: self),
            AuthenticationView(viewModel: viewModel),
            MigrationView(viewModel: viewModel)
        ]).vertical()
        
        contentView.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            stack.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stack.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
}
