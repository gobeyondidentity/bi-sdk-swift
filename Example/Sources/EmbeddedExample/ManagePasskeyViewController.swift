import Anchorage
import BeyondIdentityEmbedded
import UIKit
import SharedDesign

class ManagePasskeyViewController: ScrollableViewController {
    private let viewModel: EmbeddedViewModel
    
    var passkeyToDelete: Passkey.Id?
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        view.backgroundColor = Colors.background.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardObserver()
        hideKeyboardWhenTappedOutside()
        
        let passkeyTitle = UILabel().wrap().withText(Localized.passkeyTitle.string).withFont(Fonts.largeTitle)
        
        let getPasskeys = Card(
            title: Localized.viewPasskeyTitle.string,
            detail: Localized.passkeyText.string,
            cardView: ButtonView(
                buttonTitle: Localized.viewPasskeyTitle.string
            ){ callback in
                Embedded.shared.getPasskeys { result in
                    switch result {
                    case let .success(passkeys):
                        guard !passkeys.isEmpty else {
                            callback(Localized.noPasskeyFound.string)
                            return
                        }
                        callback(passkeys.map({$0.description}).joined())
                    case let .failure(error):
                        callback(error.localizedDescription)
                    }
                }
            }
        )

        let deletePasskey = Card(
            title: Localized.deleteTitle.string,
            detail: Localized.deleteText.string,
            cardView: InputView<Passkey.Id>(
                buttonTitle: Localized.deleteTitle.string,
                placeholder: Localized.deletePlaceholder.string
            ){ (id, callback) in
                Embedded.shared.deletePasskey(for: id) { result in
                    switch result {
                    case .success:
                        callback("Deleted Passkey Id: \(id.value)")
                    case let .failure(error):
                        callback(error.localizedDescription)
                    }
                }
            }
        )
        
        let stack = UIStackView(arrangedSubviews: [
            passkeyTitle,
            getPasskeys,
            Line(),
            deletePasskey
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

