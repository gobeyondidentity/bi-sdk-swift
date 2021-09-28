import Anchorage
import Embedded
import SharedDesign

#if os(iOS)
import UIKit

class ShowQRCodeViewController: ViewController {
    private let activityIndicator = UIActivityIndicatorView()
    private let cancelErrorMessage = CancelErrorMessage()
    
    // used to track which error to display
    private(set) var exportHasStarted = false
    
    private let qrCodeErrorImage = UIImageView(image: .qrCodeUnavailable)
    
    private let exportErrorLabel = Label()
        .wrap()
        .withFont(Fonts.body)
        .withColor(Colors.error.value)
    
    private let infoLabel = Label()
        .wrap()
        .withFont(Fonts.body)
        .withColor(Colors.body.value)
    
    private let tokenLabel = Label()
        .wrap()
        .withFont(Fonts.body)
        .withColor(Colors.body.value)
    
    let qrCodeStack = StackView()
    
    init(credential: Credential, appName: String) {
        super.init(nibName: nil, bundle: nil)
        
        activityIndicator.color = Colors.body.value
        
        startExport(with: credential.handle)
        
        title = LocalizedString.settingShowQRCodeTitle.string
        infoLabel.text = LocalizedString.settingShowQRCodeInfo.format(appName)
        
        if #available(iOS 13.0, *) {
            // Removed option to swipe down on modal. This forces the user to leave screen by tapping "Cancel" button in order to properly cancel an export
            isModalInPresentation = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background.value
        
        exportErrorLabel.isHidden = true
        exportErrorLabel.textAlignment = .center
        cancelErrorMessage.isHidden = true
        
        let cancelButton = UIBarButtonItem(title: LocalizedString.settingCancelExportButton.string, style: .plain, target: self, action: #selector(cancelExportBeforeGoingBack))
        navigationItem.leftBarButtonItem = cancelButton
        
        qrCodeErrorImage.contentMode = .scaleAspectFit
        qrCodeErrorImage.isHidden = true
        qrCodeErrorImage.heightAnchor == view.bounds.width / 2
        
        infoLabel.isHidden = true
        infoLabel.textAlignment = .center
        
        tokenLabel.textAlignment = .center
        
        let stack = StackView(arrangedSubviews: [cancelErrorMessage, activityIndicator, qrCodeStack, qrCodeErrorImage, exportErrorLabel, infoLabel, tokenLabel])
        stack.axis = .vertical
        stack.spacing = Spacing.large
        
        view.addSubview(stack)
        
        stack.topAnchor == view.safeAreaLayoutGuide.topAnchor + Spacing.offsetFromTop(view)
        stack.bottomAnchor <= view.safeAreaLayoutGuide.bottomAnchor
        stack.horizontalAnchors == view.safeAreaLayoutGuide.horizontalAnchors + Spacing.padding
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelExportBeforeGoingBack(sender: UIBarButtonItem) {
        Embedded.shared.cancelExport { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.cancelErrorMessage.isHidden = true
                self.navigationController?.popViewController(animated: true)
            case let .failure(error):
                print(error)
                self.cancelErrorMessage.isHidden = false
            }
        }
    }
    
    func startExport(with handle: Credential.Handle) {
        activityIndicator.startAnimating()
        
        Embedded.shared.export(handles: [handle]) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(exportStatus):
                switch exportStatus {
                case let .started(token, qrImage), let .tokenUpdated(token, qrImage):
                    self.exportHasStarted = true
                    self.activityIndicator.stopAnimating()
                    self.exportErrorLabel.isHidden = true
                    self.qrCodeErrorImage.isHidden = true
                    self.updateCodes(image: qrImage, token: token.value)
                case .done:
                    self.navigationController?.popViewController(animated: true)
                }
            case let .failure(error):
                if !error.localizedDescription.lowercased().contains("aborted") {
                    print(error.localizedDescription)
                    if self.exportHasStarted {
                        // problem with exporting
                        self.exportErrorLabel.text = LocalizedString.settingExportError.string
                        self.exportErrorLabel.isHidden = false
                    } else {
                        // problem loading
                        self.activityIndicator.stopAnimating()
                        self.exportErrorLabel.text = LocalizedString.settingExportQRError.string
                        self.exportErrorLabel.isHidden = false
                        self.qrCodeErrorImage.isHidden = false
                    }
                }
            }
        }
    }
    
    private func updateCodes(image: QRCode?, token: String) {
        updateQRCode(image: image)
        infoLabel.isHidden = false
        let formattedToken = token.separate(with: "-")
        tokenLabel.text = LocalizedString.settingNoCameraCode.format(formattedToken)
    }
    
    private func updateQRCode(image: QRCode?) {
        qrCodeStack.clear()
        let qrCode = ImageView()
        qrCode.contentMode = .scaleAspectFit
        qrCode.image = image
        qrCodeStack.addArrangedSubview(qrCode)
    }
    
}
#endif

fileprivate extension String {
    func separate(every stride: Int = 3, with separator: Character) -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
}

fileprivate extension UIStackView {
    func clear() {
        for arrangedSubview in self.arrangedSubviews {
            self.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
    }
}


class CancelErrorMessage: UIView {
    private let errorMessage = Label()
        .wrap()
        .withFont(Fonts.body)
        .withText(LocalizedString.settingCancelExportError.string)
        .withColor(Colors.error.value)
    
    init(){
        super.init(frame: .zero)
        errorMessage.textAlignment = .center
        
        backgroundColor = Colors.dangerSurface.value
        addSubview(errorMessage)
        
        errorMessage.verticalAnchors == verticalAnchors + Spacing.padding
        errorMessage.horizontalAnchors == horizontalAnchors + Spacing.padding
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
