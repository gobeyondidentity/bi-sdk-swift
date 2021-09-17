import Anchorage
import Foundation
import SharedDesign

#if os(iOS)
import UIKit

class PopUpView: View {
    let titleLabel = Label()
        .wrap()
        .withFont(Fonts.title)
        .withColor(Colors.heading.value)
    
    let infoLabel = Label()
        .wrap()
        .withFont(Fonts.body)
        .withColor(Colors.body.value)
    
    let button: Button
    let primaryAction: () -> Void
    let closeAction: () -> Void
    
    init(
        title: String,
        info: String,
        buttonTitle: String,
        primaryAction: @escaping () -> Void,
        closeAction: @escaping () -> Void
    ) {
        button = StandardButton(title: buttonTitle)
        self.primaryAction = primaryAction
        self.closeAction = closeAction
        
        super.init(frame: .zero)
        
        titleLabel.text = title
        infoLabel.text = info
        setUpSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius(for: .small)
    }
    
    private func setUpSubviews() {
        backgroundColor = Colors.background.value
        
        let closeButton = Button()
        closeButton.setImage(.close?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = Colors.heading.value
        closeButton.addTarget(self, action: #selector(tappedClose), for: .touchUpInside)
        
        titleLabel.textAlignment = .center
        
        infoLabel.textAlignment = .center
        
        button.addTarget(self, action: #selector(tappedPrimaryButton), for: .touchUpInside)
        
        let stack = StackView(arrangedSubviews: [titleLabel, infoLabel, button])
        stack.axis = .vertical
        stack.spacing = Spacing.padding
        
        addSubview(stack)
        addSubview(closeButton)
        
        closeButton.topAnchor ==  topAnchor + Spacing.medium
        closeButton.leadingAnchor == leadingAnchor + Spacing.medium
        
        stack.horizontalAnchors == horizontalAnchors + Spacing.padding
        stack.topAnchor == closeButton.bottomAnchor + Spacing.large
        stack.bottomAnchor == bottomAnchor - Spacing.padding
    }
    
    @objc private func tappedPrimaryButton(){
        primaryAction()
    }
    
    @objc private func tappedClose(){
        closeAction()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
