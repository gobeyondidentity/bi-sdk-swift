import Anchorage
import BeyondIdentityEmbedded
import SharedDesign

#if os(iOS)
import UIKit

class CredentialView: View {
    private let credential: Credential
    
    let logo = ImageView(image: .key)
    
    let title = Label()
        .wrap()
        .withFont(Fonts.title2)
        .withColor(Colors.navBarText.value)
    
    let info = Label()
        .wrap()
        .withFont(Fonts.body)
        .withText(LocalizedString.settingDeviceName.format(UIDevice.current.name))
        .withColor(Colors.body.value)
    
    init(appName: String, credential: Credential) {
        self.credential = credential
        super.init(frame: .zero)
        title.text = appName
        setUpSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureWithShadowBorder(for: .credentialCard)
    }
    
    func setUpSubviews() {
        title.textAlignment = .center
        info.textAlignment = .center
        
        if let logoURL = URL(string: credential.logoURL) {
            logo.load(url: logoURL)
        } else {
            logo.setImageColor(color: Colors.body.value)
        }
        
        logo.contentMode = .scaleAspectFit

        logo.heightAnchor == 40
        
        let stack = StackView(arrangedSubviews: [logo, title, info])
        stack.axis = .vertical
        stack.setCustomSpacing(Spacing.padding, after: logo)
        stack.setCustomSpacing(Spacing.medium, after: title)
        
        addSubview(stack)
        
        stack.verticalAnchors >= verticalAnchors + Spacing.section
        stack.horizontalAnchors >= horizontalAnchors + Spacing.padding
        stack.centerAnchors == centerAnchors
    }
    
    @available(*, unavailable)
    required init?(coder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
