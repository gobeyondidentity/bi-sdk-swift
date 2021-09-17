import Anchorage
import SharedDesign

#if os(iOS)
import UIKit

class DeleteWarningView: View {
    let cancelAction: () -> Void
    let deleteAction: () -> Void
    
    init(
        cancelAction: @escaping() -> Void,
        deleteAction: @escaping () -> Void
    ) {
        self.cancelAction = cancelAction
        self.deleteAction = deleteAction
        
        super.init(frame: .zero)
        
        setUpSubviews()
    }
    
    func setUpSubviews() {
        backgroundColor = Colors.background.value
        
        let closeButton = Button()
        closeButton.setImage(.close?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = Colors.heading.value
        closeButton.addTarget(self, action: #selector(tappedCancel), for: .touchUpInside)
        
        let titleLabel = Label()
            .wrap()
            .withFont(Fonts.title)
            .withText(LocalizedString.settingDeleteWarningTitle.string)
            .withColor(Colors.heading.value)
        
        let infoLabel = Label()
            .wrap()
            .withFont(Fonts.body)
            .withText(LocalizedString.settingDeleteWarning.string)
            .withColor(Colors.body.value)
        
        titleLabel.textAlignment = .center
        infoLabel.textAlignment = .center
        
        let cancelButton = Button(type: .roundedRect)
        cancelButton.setTitle(LocalizedString.settingCancelButton.string, for: .normal)
        cancelButton.addTarget(self, action: #selector(tappedCancel), for: .touchUpInside)
        cancelButton.backgroundColor = Colors.background.value
        cancelButton.setCornerRadius(for: .small)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = Colors.border.value.cgColor
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: Spacing.medium, left: 0, bottom: Spacing.medium, right: 0)
        
        let deleteButton = Button(type: .roundedRect)
        deleteButton.setTitle(LocalizedString.settingDeleteButton.string, for: .normal)
        deleteButton.setTitleColor(Colors.standardButtonText.value, for: .normal)
        deleteButton.addTarget(self, action: #selector(tappedDelete), for: .touchUpInside)
        deleteButton.backgroundColor = Colors.danger.value
        deleteButton.setCornerRadius(for: .small)
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.borderColor = Colors.danger.value.cgColor
        deleteButton.contentEdgeInsets = UIEdgeInsets(top: Spacing.medium, left: 0, bottom: Spacing.medium, right: 0)
        
        let buttons = StackView(arrangedSubviews: [cancelButton, deleteButton])
        buttons.spacing = Spacing.medium
        buttons.distribution = .fillEqually
        
        let stack = StackView(arrangedSubviews: [titleLabel, infoLabel, buttons])
        stack.axis = .vertical
        stack.spacing = Spacing.padding
        
        addSubview(closeButton)
        addSubview(stack)
        
        closeButton.topAnchor ==  topAnchor + Spacing.medium
        closeButton.leadingAnchor == leadingAnchor + Spacing.medium
        stack.horizontalAnchors == horizontalAnchors + Spacing.padding
        stack.topAnchor == closeButton.bottomAnchor + Spacing.large
        stack.bottomAnchor == bottomAnchor - Spacing.padding
    }
    
    @objc func tappedCancel(){
        cancelAction()
    }
    
    @objc func tappedDelete(){
        deleteAction()
    }
    
    @available(*, unavailable)
    required init?(coder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
