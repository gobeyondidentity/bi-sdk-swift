import Anchorage
import Embedded
import SharedDesign

#if os(iOS)
import UIKit

class CredentialExistsView: View {
    struct TextConfig {
        let infoText: String
        let primaryText: String
        let secondaryText: String
    }
    
    private let textConfig: TextConfig
    private let primaryAction: () -> Void
    private let secondaryAction: () -> Void
    
    init(
        textConfig: TextConfig,
        primaryAction: @escaping () -> Void,
        secondaryAction: @escaping () -> Void
    ) {
        self.textConfig = textConfig
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        
        super.init(frame: .zero)
        
        setUpSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureWithShadowBorder()
    }
    
    private func setUpSubviews() {
        let infoLabel = Label()
            .wrap()
            .withFont(Fonts.body)
            .withText(textConfig.infoText)
            .withColor(Colors.body.value)
        
        infoLabel.textAlignment = .center
        
        let primaryButton = StandardButton(title: textConfig.primaryText)
        primaryButton.addTarget(self, action: #selector(tapPrimaryButton), for: .touchUpInside)
        
        let secondaryButton = Button().wrap()
        secondaryButton.setTitle(textConfig.secondaryText, for: .normal)
        secondaryButton.setTitleColor(Colors.link.value, for: .normal)
        secondaryButton.titleLabel?.setFont(Fonts.body)
        secondaryButton.addTarget(self, action: #selector(tapSecondaryButton), for: .touchUpInside)
        
        let stack = StackView(arrangedSubviews: [
            infoLabel,
            primaryButton,
            secondaryButton
        ])
        stack.axis = .vertical
        stack.spacing = Spacing.large
        
        addSubview(stack)
        
        stack.horizontalAnchors == horizontalAnchors + Spacing.padding
        stack.verticalAnchors == verticalAnchors + Spacing.padding
    }
    
    @objc private func tapPrimaryButton() {
        primaryAction()
    }
    
    @objc private func tapSecondaryButton() {
        secondaryAction()
    }
    
    @available(*, unavailable)
    required init?(coder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
