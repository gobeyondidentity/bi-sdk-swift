import Anchorage
import AVFoundation
import Foundation
import SharedDesign

#if os(iOS)
import UIKit

class SignUpViewController: ScrollableViewController {
    private let authType: AuthFlowType
    private let config: BeyondIdentityConfig
    private let type: SignUpView.CredentialType
    
    init(
        authType: AuthFlowType,
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
        
        let alternateOptionsToSignUpView = makeAltTextView()
        
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
    
    func makeAltTextView() -> View {
        let addToDevice = Button()
        addToDevice.setTappableText(
            text: LocalizedString.alternateOptionsAddDeviceText.string,
            tappableText: LocalizedString.alternateOptionsAddDeviceTappableText.string
        )
        addToDevice.addTarget(self, action: #selector(tappedAddToDevice), for: .touchUpInside)
        
        let recoverAccount = Button()
        recoverAccount.setTappableText(text: LocalizedString.alternateOptionsRecoverAccountText.string, tappableText: LocalizedString.alternateOptionsRecoverAccountTappableText.string)
        recoverAccount.addTarget(self, action: #selector(tappedRecoverAccount), for: .touchUpInside)
        
        let visitSupport = Button()
        visitSupport.setTappableText(text: LocalizedString.alternateOptionsVisitSupportText.string, tappableText: LocalizedString.alternateOptionsVisitSupportTappableText.string)
        visitSupport.addTarget(self, action: #selector(tappedVisitSupport), for: .touchUpInside)
        
        let stack = StackView(arrangedSubviews: [addToDevice, recoverAccount, visitSupport])
        stack.axis = .vertical
        stack.alignment = .center
        
        return stack
    }
    
    @objc func tappedAddToDevice(){
        navigateToAddDevice(
            with: navigationController,
            for: .button(authType),
            config: config
        )
    }
    
    @objc func tappedRecoverAccount(){
        navigationController?.dismiss(animated: true, completion: { [weak self] in
            self?.config.recoverUserAction()
        })
    }
    
    @objc func tappedVisitSupport(){
        openSupport(url: config.supportURL)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
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
#else
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
#endif
}

func openSupport(url: URL){
    guard UIApplication.shared.canOpenURL(url) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
}
#endif


