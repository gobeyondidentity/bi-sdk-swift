import Anchorage
import SharedDesign

#if os(iOS)
import UIKit

class SignUpView: View {
    enum CredentialType {
        case noCredential
        case existingCredential
    }
    
    private let titleLabel = Label()
        .wrap()
        .withFont(Fonts.title)
        .withColor(Colors.heading.value)
    
    private let descriptionLabel = Label()
        .wrap()
        .withFont(Fonts.body)
        .withColor(Colors.body.value)
    
    private let credentialLink = Button().wrap()
    
    private let credentialAction: () -> Void
    private let signUpAction: () -> Void
    
    private let signUpButtonTitle: String
    
    init(
        type: CredentialType,
        credentialAction: @escaping () -> Void,
        signUpAction: @escaping () -> Void
    ) {
        self.credentialAction = credentialAction
        self.signUpAction = signUpAction
        self.signUpButtonTitle = type == .noCredential ? LocalizedString.signUpActionButton.string : LocalizedString.signUpAddAnotherCredentialButton.string
        super.init(frame: .zero)
        
        switch type {
        case .noCredential:
            titleLabel.text = LocalizedString.signUpTitle.string
            descriptionLabel.isHidden = true
        case .existingCredential:
            titleLabel.text = LocalizedString.signUpAddAnotherCredentialTitle.string
            descriptionLabel.text = LocalizedString.signUpAddAnotherCredentialDetail.string
        }
        
        setUpSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureWithShadowBorder(for: .signUp)
    }
    
    private func setUpSubviews() {
        titleLabel.textAlignment = .center
        descriptionLabel.textAlignment = .center
        
        let signUpButton = StandardButton(title: signUpButtonTitle )
        signUpButton.addTarget(self, action: #selector(tapSignUp), for: .touchUpInside)
        
        credentialLink.setTitle(LocalizedString.credentialTitle.string, for: .normal)
        credentialLink.setTitleColor(Colors.link.value, for: .normal)
        credentialLink.titleLabel?.setFont(Fonts.body)
        credentialLink.addTarget(self, action: #selector(tapCredentialLink), for: .touchUpInside)
        
        let stack = StackView(arrangedSubviews: [titleLabel, descriptionLabel, signUpButton, credentialLink])
        stack.axis = .vertical
        stack.spacing = Spacing.large
        
        addSubview(stack)
        
        stack.horizontalAnchors == horizontalAnchors + Spacing.padding
        stack.verticalAnchors == verticalAnchors + Spacing.padding
    }
    
    @objc private func tapSignUp() {
        signUpAction()
    }
    
    @objc private func tapCredentialLink() {
        credentialAction()
    }
    
    @available(*, unavailable)
    required init?(coder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
