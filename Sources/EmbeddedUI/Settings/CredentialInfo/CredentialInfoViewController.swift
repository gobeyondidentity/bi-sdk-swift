import Anchorage
import BeyondIdentityEmbedded
import SharedDesign

#if os(iOS)
import UIKit

class CredentialInfoViewController: ScrollableViewController {
    private let appName: String
    private let credential: Credential
    
    init(credential: Credential, appName: String) {
        self.appName = appName
        self.credential = credential
        super.init()
        
        title = LocalizedString.settingCredentialInfoTitle.string
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background.value
        
        let credentialCard = CredentialView(appName: appName, credential: credential)
        let deviceInfoView = DeviceInfoView()
        
        let deleteButton = Button().wrap()
        deleteButton.setTitle(LocalizedString.settingDeleteCredentialButton.string, for: .normal)
        deleteButton.setTitleColor(Colors.error.value, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteCredential), for: .touchUpInside)
        
        contentView.addSubview(credentialCard)
        contentView.addSubview(deviceInfoView)
        contentView.addSubview(deleteButton)
        
        credentialCard.heightAnchor == view.bounds.width - (Spacing.padding * 4)
        credentialCard.topAnchor == contentView.safeAreaLayoutGuide.topAnchor + Spacing.offsetFromTop(view)
        credentialCard.horizontalAnchors == contentView.horizontalAnchors + (Spacing.padding * 2)
        deviceInfoView.topAnchor == credentialCard.bottomAnchor + Spacing.section
        deviceInfoView.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors
        deleteButton.topAnchor == deviceInfoView.bottomAnchor + Spacing.section
        deleteButton.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + Spacing.section
        deleteButton.bottomAnchor <= contentView.safeAreaLayoutGuide.bottomAnchor - Spacing.section
    }
    
    @objc func deleteCredential(){
        let popUpView = DeleteWarningView(
            cancelAction: cancelAction,
            deleteAction: deleteAction
        )
        present(PopUpViewController(popUpView: popUpView), animated: true, completion: nil)
    }
    
    func cancelAction(){
        dismiss(animated: true, completion: nil)
    }
    
    func deleteAction() {
        guard let handle = credential.handle else {
            let alert = ErrorAlert(
                title: LocalizedString.settingDeleteCredentialError.string,
                message: LocalizedString.credentialHandleError.string,
                responseTitle: LocalizedString.alertErrorAction.string
            )
            alert.show(with: self)
            return
        }
        Embedded.shared.deleteCredential(for: handle) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.dismiss(animated: true, completion: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                })
            case let .failure(error):
                let alert = ErrorAlert(
                    title: LocalizedString.settingDeleteCredentialError.string,
                    message: error.localizedDescription,
                    responseTitle: LocalizedString.alertErrorAction.string
                )
                alert.show(with: self)
            }
        }
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
