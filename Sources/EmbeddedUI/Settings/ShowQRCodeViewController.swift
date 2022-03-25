import Anchorage
import BeyondIdentityEmbedded
import SharedDesign

#if os(iOS)
import UIKit

class ShowQRCodeViewController: ViewController {
    private let activityIndicator = UIActivityIndicatorView()
    private let cancelErrorMessage = CancelErrorMessage()
    
    // used to track which error to display
    private(set) var exportHasStarted = false
    
    private let qrCodeErrorImage = UIImageView(image: .qrCodeUnavailable)
    
    private let extendErrorLabel = Label()
        .wrap()
        .withFont(Fonts.body)
        .withColor(Colors.error.value)

    private let line = Line()
    
    private let infoLabel = Label()
        .wrap()
        .withFont(Fonts.body)
        .withColor(Colors.body.value)
    
    private let qrCodeText = Label()
        .wrap()
        .withFont(Fonts.body)
        .withColor(Colors.body.value)

    private let tokenLabel = Label()
        .wrap()
        .withFont(Fonts.title2)
        .withColor(Colors.body.value)
    
    let qrCodeStack = StackView()

    init(credential: Credential, appName: String) {
        super.init(nibName: nil, bundle: nil)
        
        activityIndicator.color = Colors.body.value
        
        startExport(with: credential.handle)
        
        title = LocalizedString.settingShowQRCodeTitle.string
        infoLabel.text = LocalizedString.settingShowQRCodeInfo.format(appName)
        
        if #available(iOS 13.0, *) {
            // Removed option to swipe down on modal. This forces the user to leave screen by tapping "Cancel" button in order to properly cancel an extend
            isModalInPresentation = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background.value
        
        extendErrorLabel.isHidden = true
        extendErrorLabel.textAlignment = .center
        cancelErrorMessage.isHidden = true

        let cancelButton = UIBarButtonItem(title: LocalizedString.settingCancelExtendCredentialsButton.string, style: .plain, target: self, action: #selector(cancelExtendCredentialsBeforeGoingBack))
        navigationItem.leftBarButtonItem = cancelButton

        qrCodeErrorImage.contentMode = .scaleAspectFit
        qrCodeErrorImage.isHidden = true
        qrCodeErrorImage.heightAnchor == view.bounds.width / 2
        
        infoLabel.isHidden = true
        infoLabel.textAlignment = .center

        line.isHidden = true
        
        qrCodeText.setTextWithLineSpacing(text: LocalizedString.settingNoCameraCode.string, lineSpacing: Spacing.large)
        qrCodeText.textAlignment = .center
        qrCodeText.isHidden = true

        tokenLabel.textAlignment = .center
        tokenLabel.isHidden = true

        let qrCodeTextContainer = StackView(arrangedSubviews: [infoLabel, line, qrCodeText, tokenLabel])
        qrCodeTextContainer.axis = .vertical
        qrCodeTextContainer.spacing = Spacing.large

        let stack = StackView(arrangedSubviews: [cancelErrorMessage, activityIndicator, qrCodeStack, qrCodeErrorImage, extendErrorLabel, qrCodeTextContainer])
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
    
    @objc func cancelExtendCredentialsBeforeGoingBack(sender: UIBarButtonItem) {
        Embedded.shared.cancelExtendCredentials { [weak self] result in
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
    
    func startExport(with handle: Credential.Handle?) {
        guard let handle = handle else {
            extendErrorLabel.text = LocalizedString.credentialHandleError.string
            extendErrorLabel.isHidden = false
            return
        }
        
        activityIndicator.startAnimating()
        
        Embedded.shared.extendCredentials(handles: [handle]) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(extendCredentialsStatus):
                switch extendCredentialsStatus {
                case .aborted:
                    break
                case let .started(token, qrImage), let .tokenUpdated(token, qrImage):
                    self.exportHasStarted = true
                    self.activityIndicator.stopAnimating()
                    self.extendErrorLabel.isHidden = true
                    self.qrCodeErrorImage.isHidden = true
                    self.updateCodes(image: qrImage, token: token.value)
                case .done:
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure:
                if self.exportHasStarted {
                    // problem with exporting
                    self.extendErrorLabel.text = LocalizedString.settingExtendCredentialsError.string
                    self.extendErrorLabel.isHidden = false
                } else {
                    // problem loading
                    self.activityIndicator.stopAnimating()
                    self.extendErrorLabel.text = LocalizedString.settingExtendCredentialsQRError.string
                    self.extendErrorLabel.isHidden = false
                    self.qrCodeErrorImage.isHidden = false
                }
            }
        }
    }
    
    private func updateCodes(image: QRCode?, token: String) {
        updateQRCode(image: image)
        infoLabel.isHidden = false
        qrCodeText.isHidden = false
        line.isHidden = false
        tokenLabel.isHidden = false
        tokenLabel.text = token.separate(with: "-")
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
        .withText(LocalizedString.settingCancelExtendCredentialsError.string)
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
