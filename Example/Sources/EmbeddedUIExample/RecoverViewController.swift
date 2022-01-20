import UIKit

class RecoverViewController: UIViewController {
    private let recoveryURL: URL

    init(recoveryURL: URL) {
        self.recoveryURL = recoveryURL
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "Your Recover Screen"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedOutside()
        
        let recoveryView = RecoveryView(recoveryURL: recoveryURL, for: self)
        
        view.addSubview(recoveryView)
        
        recoveryView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            recoveryView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recoveryView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
