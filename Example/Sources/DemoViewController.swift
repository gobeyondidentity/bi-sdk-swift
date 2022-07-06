import Anchorage
import UIKit
import SharedDesign

class DemoViewController: ScrollableViewController {
    
    override init() {
        super.init()
        view.backgroundColor = Colors.background.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let beyondIdentityTitle = UILabel()
            .wrap()
            .withText(Localized.beyondIdentityTitle.string)
            .withFont(Fonts.largeTitle)
        
        let beyondIdentityText =  UILabel()
            .wrap()
            .withText(Localized.beyondIdentityText.string)
            .withFont(Fonts.title2)
        
        let version = UILabel()
            .wrap()
            .withText("Version: \(EmbeddedViewModel().sdkVersion)")
            .withFont(Fonts.medium)
            .withColor(.lightGray)
        
        let embeddedButton = makeButton(with: Localized.embeddedButton.string)
        embeddedButton.addTarget(self, action: #selector(toEmbedded), for: .touchUpInside)
        
        let embeddedSDK = makeSDKCard(
            title: Localized.embeddedSdkTitle.string,
            text: Localized.embeddedSdkText.string,
            button: embeddedButton
        )
        
        let stack = UIStackView(arrangedSubviews: [
            beyondIdentityTitle,
            version,
            beyondIdentityText,
            embeddedSDK
        ]).vertical()
        
        stack.setCustomSpacing(Spacing.large, after: beyondIdentityTitle)
        stack.setCustomSpacing(Spacing.large, after: version)
        stack.spacing = Spacing.padding
        stack.alignment = .fill
        
        contentView.addSubview(stack)
        
        stack.horizontalAnchors == contentView.horizontalAnchors + 16
        stack.verticalAnchors == contentView.verticalAnchors + 16
    }
    
    private func makeSDKCard(title: String, text: String, button: Button) -> View {
        let title = UILabel().wrap().withText(title).withFont(Fonts.largeTitle)
        let text =  UILabel().wrap().withText(text).withFont(Fonts.title2)
        
        let stack = UIStackView(arrangedSubviews: [
            title,
            text,
            button,
        ]).vertical()
        
        stack.alignment = .fill
        stack.spacing = Spacing.large
        return stack
    }
    
    @objc func toEmbedded() {
        navigationController?.pushViewController(
            EmbeddedViewController(viewModel: EmbeddedViewModel()), animated: true)
    }
}
