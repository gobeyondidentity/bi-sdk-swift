import Anchorage
import SharedDesign

#if os(iOS)
import UIKit

class AddCredentialSuccessViewController: ScrollableViewController {
    private let infoLabel = Label()
        .wrap()
        .withFont(Fonts.body)
        .withColor(Colors.body.value)
    
    init(appName: String) {
        super.init()
        
        title = LocalizedString.settingAddCredentialTitle.string
        infoLabel.text = LocalizedString.settingCredentialSetUpInfo.format(appName, appName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background.value
        
        infoLabel.textAlignment = .center
        
        let confirmationButton = StandardButton(title: LocalizedString.settingCredentialSetUpButton.string)
        confirmationButton.addTarget(self, action: #selector(tappedConfirmation), for: .touchUpInside)
        
        let stack = StackView(arrangedSubviews: [infoLabel, confirmationButton])
        stack.axis = .vertical
        stack.spacing = Spacing.large
        
        contentView.addSubview(stack)
        
        stack.topAnchor == contentView.safeAreaLayoutGuide.topAnchor + Spacing.padding
        stack.bottomAnchor <= contentView.safeAreaLayoutGuide.bottomAnchor
        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + Spacing.padding
    }
    
    @objc func tappedConfirmation() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
