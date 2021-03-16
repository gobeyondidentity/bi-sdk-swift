import AuthenticationServices
import UIKit
import BISDK

class PreLoggedInViewController: UIViewController {
    let viewModel: PreLoggedInViewModel
    
    init(viewModel: PreLoggedInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = viewModel.navigationTitle
        
        /*  ! WARNING !
         Custom URL Schemes offer a potential attack as iOS allows any URL Scheme to be claimed by multiple apps
         and thus malicious apps can hijack sensitive data. To mitigate this risk, please use
         Universal Links in your production app */
        
        let button = AuthView(
            session: ASWebAuthenticationSession(
                url: viewModel.cloudURL,
                callbackURLScheme: viewModel.urlScheme,
                completionHandler: { [weak self] url, error in
                    if let error = error { self?.signInCallBack(.failure(error)) }
                    if let url = url { self?.signInCallBack(.success(url)) }
                }
            ),
            signUpAction: signUpAction)
        
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func signInCallBack(_ result: Result<URL, Error>) {
        switch result {
        case let .success(url):
            let sessionToken = URLComponents(string: url.absoluteString)?.queryItems?.filter({$0.name == "session" }).first?.value
            let viewModel = LoggedInViewModel(session: sessionToken!)
            self.navigationController?.pushViewController(LoggedInViewController(viewModel:viewModel), animated: true)
        case let .failure(error):
            print(error)
        }
    }
    
    func signUpAction() {
        let inputViewController = InputViewController({ [weak self] email in
            self?.viewModel.enroll(with: email) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self?.alert("Enrollment was sucessful", "Check your email!") {[weak self] _ in
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                case let .failure(error):
                    DispatchQueue.main.async {
                        self?.alert("Enrollment failed, try again", error.localizedDescription)
                    }
                }
            }
        })
        
        self.navigationController?.pushViewController(inputViewController, animated: true)
    }
    
    func alert(_ title: String, _ message: String? = nil, _ handler: ((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        self.present(alert, animated: true)
    }
}
