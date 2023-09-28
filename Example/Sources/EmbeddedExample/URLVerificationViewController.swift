import Anchorage
import BeyondIdentityEmbedded
import UIKit
import SharedDesign

class URLVerificationViewController: ScrollableViewController {
    private let viewModel: EmbeddedViewModel
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        view.backgroundColor = Colors.background.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardObserver()
        hideKeyboardWhenTappedOutside()
        
        let title = UILabel().wrap().withText(Localized.urlVerificationButton.string).withFont(Fonts.largeTitle)
        
        let stack = UIStackView(arrangedSubviews: [
            title,
            Card(
                title: Localized.isAuthenticateTitle.string,
                detail: Localized.isAuthenticateText.string,
                cardView: InputView<URL>(
                    buttonTitle: Localized.validateAuthenticateButton.string,
                    placeholder: Localized.isAuthenticateTitle.string
                ){ (url, callback) in
                    if Embedded.shared.isAuthenticateUrl(url){
                        callback("true")
                    }else {
                        callback("false")
                    }
                }
            ),
            Line(),
            Card(
                title: Localized.isBindTitle.string,
                detail: Localized.isBindText.string,
                cardView: InputView<URL>(
                    buttonTitle: Localized.validateBindPasskeyButton.string,
                    placeholder: Localized.isBindTitle.string
                ){ (url, callback) in
                    if Embedded.shared.isBindPasskeyUrl(url){
                        callback("true")
                    }else {
                        callback("false")
                    }
                }
            )
        ]).vertical()
        stack.alignment = .fill
        stack.spacing = Spacing.padding
        
        contentView.addSubview(stack)
        
        stack.verticalAnchors == contentView.safeAreaLayoutGuide.verticalAnchors + Spacing.large
        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + Spacing.large
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

