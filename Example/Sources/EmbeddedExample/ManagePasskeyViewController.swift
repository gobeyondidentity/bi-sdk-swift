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
                do {
                    let passkeys = try await Embedded.shared.getPasskeys()
                    guard !passkeys.isEmpty else {
                        callback(Localized.noPasskeyFound.string)
                        return
                    }
                    callback(passkeys.map({$0.description}).joined())
                } catch {
                    callback(error.localizedDescription)
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
                do {
                    try await Embedded.shared.deletePasskey(for: id)
                    callback("Deleted Passkey Id: \(id.value)")
                } catch {
                    callback(error.localizedDescription)
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

