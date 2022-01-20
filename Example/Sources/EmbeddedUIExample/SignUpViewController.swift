import UIKit

class SignUpViewController: UIViewController {
    private let registrationURL: URL
    
    init(registrationURL: URL) {
        self.registrationURL = registrationURL
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "Your Sign up Screen"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedOutside()
        
        let registrationView = RegistrationView(registrationURL: registrationURL, for: self)
        
        view.addSubview(registrationView)
        
        registrationView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            registrationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
