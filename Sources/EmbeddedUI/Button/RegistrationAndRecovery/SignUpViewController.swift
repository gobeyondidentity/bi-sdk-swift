import Anchorage
import AVFoundation
import Foundation
import SharedDesign

#if os(iOS)
import UIKit

class SignUpViewController: ScrollableViewController {
    private let authType: FlowType
    private let config: BeyondIdentityConfig
    private let type: SignUpView.CredentialType
    
    init(
        authType: FlowType,
        config: BeyondIdentityConfig,
        type: SignUpView.CredentialType
    ) {
        self.authType = authType
        self.config = config
        self.type = type
        super.init()
        title = LocalizedString.signUpScreenTitle.string
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.background.value
        
        let poweredByBILogo = ImageView(image: .poweredByBILogo)
        poweredByBILogo.contentMode = .scaleAspectFit
        poweredByBILogo.setImageColor(color: Colors.body.value)
        
        let signUpView = SignUpView(
            type: type,
            credentialAction: tapCredential,
            signUpAction: tapSignUp
        )
        
        let alternateOptionsToSignUpView = AlternateOptionsToSignUpView(delegate: self)
        
        let stack = StackView(arrangedSubviews: [
            signUpView,
            alternateOptionsToSignUpView,
            poweredByBILogo
        ])
        
        stack.axis = .vertical
        stack.setCustomSpacing(Spacing.padding, after: signUpView)
        stack.setCustomSpacing(Spacing.padding, after: alternateOptionsToSignUpView)
        
        contentView.addSubview(stack)
        
        stack.topAnchor == contentView.safeAreaLayoutGuide.topAnchor + Spacing.offsetFromTop(view)
        stack.bottomAnchor == contentView.safeAreaLayoutGuide.bottomAnchor
        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + Spacing.padding
    }
    
    private func tapSignUp(){
        navigationController?.dismiss(animated: true, completion: { [weak self] in
            self?.config.signUpAction()
        })
    }
    
    private func tapCredential() {
        let popUpView = PopUpView(
            title: LocalizedString.credentialTitle.string,
            info: LocalizedString.credentialDescription.string,
            buttonTitle: LocalizedString.credentialAcknowledge.string,
            primaryAction: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            },
            closeAction: { self.dismiss(animated: true, completion: nil) }
        )
        
        present(PopUpViewController(popUpView: popUpView), animated: true, completion: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SignUpViewController: TextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard let option = UITextView.TappableOption(rawValue: url.absoluteString) else { return false }
        
        switch option {
        case .addToDevice:
            navigateToAddDevice(
                with: navigationController,
                for: .button(authType),
                config: self.config
            )
        case .recoverAccount:
            navigationController?.dismiss(animated: true, completion: { [weak self] in
                self?.config.recoverUserAction()
            })
            
        case .visitSupport:
            openSupport(url: config.supportURL)
        }
        
        return false
    }
}

func navigateToAddDevice(
    with navigationController: UINavigationController?,
    for flow: Flow,
    config: BeyondIdentityConfig
){
#if targetEnvironment(simulator)
    let codeEntryVC = CodeEntryViewController(
        cameraRestricted: true,
        config: config,
        flow: flow
    )
    navigationController?.pushViewController(codeEntryVC, animated: true)
    return
#endif
    if case .restricted = AVCaptureDevice.authorizationStatus(for: .video) {
        let codeEntryVC = CodeEntryViewController(
            cameraRestricted: true,
            config: config,
            flow: flow
        )
        navigationController?.pushViewController(codeEntryVC, animated: true)
    }else {
        let qrScanVC = QRScanViewController(
            config: config,
            flow: flow
        )
        navigationController?.pushViewController(qrScanVC, animated: true)
    }
}

func openSupport(url: URL){
    guard UIApplication.shared.canOpenURL(url) else { return }
        
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
}
#endif


