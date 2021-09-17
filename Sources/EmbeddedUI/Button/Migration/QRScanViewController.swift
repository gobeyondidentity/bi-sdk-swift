import Anchorage
import AVFoundation
import Foundation
import SharedDesign

#if os(iOS)
import UIKit

class QRScanViewController: ScrollableViewController {
    private let config: BeyondIdentityConfig
    private let flow: Flow
    
    private let error = MigrationErrorLabel()
    private let descriptionLabel = Label()
        .wrap()
        .withText(LocalizedString.migrationScanDescription.string)
        .withFont(Fonts.body)
        .withColor(Colors.body.value)
    
    private let enableCameraAccessButton = Link(title: LocalizedString.migrationCameraEnableAccess.string, for: Fonts.body)
    private let qrScanView = QRScanView()
    private let disabledCameraView = DisabledCameraView()
    
    init(
        config: BeyondIdentityConfig,
        flow: Flow
    ) {
        self.config = config
        self.flow = flow
        
        super.init()
        title = LocalizedString.migrationScanScreenTitle.string
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        qrScanView.stopCameraSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            startCameraSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted { self?.startCameraSession() }
            }
        case .denied, .restricted:
            return
            
        @unknown default:
            return
        }
    }
    
    private func startCameraSession() {
        DispatchQueue.main.async {
            self.disabledCameraView.isHidden = true
            self.enableCameraAccessButton.isHidden = true
            self.qrScanView.isHidden = false
            self.descriptionLabel.isHidden = false
        }
        
        qrScanView.startCameraSession()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.background.value
        
        qrScanView.configure(callback: didCapture)
        qrScanView.isHidden = true
        
        let cameraStack = StackView(arrangedSubviews: [disabledCameraView, qrScanView])
        cameraStack.axis = .vertical
        
        error.isHidden = true
        
        descriptionLabel.isHidden = true
        descriptionLabel.textAlignment = .center
        
        enableCameraAccessButton.addTarget(self, action: #selector(tapToOpenSettings), for: .touchUpInside)
        
        let switchToEnterButton = Link(title: LocalizedString.migrationSwitchToEnter.string, for: Fonts.body)
        switchToEnterButton.addTarget(self, action: #selector(tapSwitchToEnter), for: .touchUpInside)
        
        let recoverOption = RecoverInsteadOfMigrate(recoverUserAction: tapRecoverUser)
        
        let stack = StackView(arrangedSubviews: [error, descriptionLabel, enableCameraAccessButton, switchToEnterButton, recoverOption])
        stack.axis = .vertical
        stack.spacing = Spacing.large
        stack.setCustomSpacing(Spacing.section, after: switchToEnterButton)
        
        contentView.addSubview(cameraStack)
        contentView.addSubview(stack)
        
        cameraStack.heightAnchor == view.bounds.width - (Spacing.padding * 4)
        cameraStack.topAnchor == contentView.safeAreaLayoutGuide.topAnchor + Spacing.offsetFromTop(view)
        cameraStack.horizontalAnchors == contentView.horizontalAnchors + (Spacing.padding * 2)
        stack.topAnchor == cameraStack.bottomAnchor + Spacing.large
        stack.bottomAnchor <= contentView.safeAreaLayoutGuide.bottomAnchor
        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + Spacing.padding
    }
    
    func didCapture(_ result: Result<(), Error>) {
        switch result {
        case .success:
            error.isHidden = true
            handleImportSuccess(
                for: self.flow,
                with: self.navigationController,
                config: config
            )
        case .failure:
            error.isHidden = false
        }
    }
    
    @objc func tapToOpenSettings() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
    }
    
    @objc func tapSwitchToEnter() {
        let enterCodeVC = CodeEntryViewController(
            config: config,
            flow: flow
        )
        navigationController?.pushViewController(enterCodeVC, animated: true)
    }
    
    @objc func tapRecoverUser() {
        navigationController?.dismiss(animated: true, completion: { [weak self] in
            self?.config.recoverUserAction()
        })
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
