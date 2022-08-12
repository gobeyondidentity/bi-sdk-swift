import BeyondIdentityEmbedded
import UIKit
import Anchorage
import SharedDesign

class EmbeddedViewController: ScrollableViewController {
    let viewModel: EmbeddedViewModel
    
    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        
        view.backgroundColor = Colors.cardBackground.value
        contentView.backgroundColor = Colors.cardBackground.value
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardObserver()
        hideKeyboardWhenTappedOutside()
        
        let embeddedTitle = UILabel().wrap().withText(Localized.viewEmbeddedSdkTitle.string).withFont(Fonts.largeTitle)
        let version = UILabel().wrap().withText("Version: \(EmbeddedViewModel().sdkVersion)").withFont(Fonts.medium).withColor(.lightGray)
        
        let titleStack = UIStackView(arrangedSubviews: [embeddedTitle, version]).vertical()
        
        let stack = UIStackView(arrangedSubviews: [
            titleStack,
            setUpGetStartedView(),
            setUpFunctionalityView(),
            setUpSupportView(),
        ]).vertical()
        stack.alignment = .fill
        stack.spacing = Spacing.padding
        
        contentView.addSubview(stack)
        
        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + Spacing.large
        stack.verticalAnchors == contentView.safeAreaLayoutGuide.verticalAnchors
    }
    
    private func setUpGetStartedView() -> View {
        let getStartedTitle = UILabel().wrap().withText(Localized.getStartedTitle.string).withFont(Fonts.largeTitle)
        
        let stack = UIStackView(arrangedSubviews: [
            getStartedTitle,
            Card(
                title: Localized.exampleBindTitle.string,
                detail: Localized.exampleBindText.string,
                cardView: InputView<String>(
                    buttonTitle: Localized.exampleBindTitle.string,
                    placeholder: Localized.examplePlaceholder.string
                ){ [weak self] (username, printToScreen) in
                    guard let self = self else { return }
                    let request = createBindRequest(
                        for: username,
                        with: self.viewModel.bindEndpoint
                    )
                    sendRequest(for: self, with: request) { data in
                        handleBindRequest(data: data, callback: printToScreen)
                    }
                }
            ),
            Card(
                title: Localized.exampleRecoverTitle.string,
                detail: Localized.exampleRecoverText.string,
                cardView: InputView<String>(
                    buttonTitle: Localized.exampleRecoverTitle.string,
                    placeholder: Localized.exampleRecoverPlaceholder.string
                ){ [weak self] (username, printToScreen) in
                    guard let self = self else { return }
                    let request = createBindRequest(
                        for: username,
                        with: self.viewModel.recoverEndpoint
                    )
                    sendRequest(for: self, with: request) { data in
                        handleBindRequest(data: data, callback: printToScreen)
                    }
                }
            ),
            Card(
                title: Localized.bindTitle.string,
                detail: Localized.bindDescription.string,
                cardView: InputView<URL>(
                    buttonTitle: Localized.bindTitle.string,
                    placeholder: Localized.bindURLPlaceholder.string
                ){ (url, printToScreen) in
                    Embedded.shared.bindCredential(url: url) { result in
                        switch result {
                        case let .success(response):
                            printToScreen(response.credential.description)
                        case let .failure(error):
                            printToScreen(error.localizedDescription)
                        }
                    }
                }
            ),
        ]).vertical()
        
        stack.alignment = .fill
        
        return stack
    }
    
    private func setUpFunctionalityView() -> View {
        let manageCredentialsButton = CustomButtonWithLine(title: Localized.manageCredentialsButton.string)
        let authenticateButton = CustomButtonWithLine(title: Localized.authenticateButton.string)
        let urlVerificationButton = CustomButtonWithLine(title: Localized.urlVerificationButton.string)
        
        manageCredentialsButton.addTarget(self, action: #selector(toManageCredentials), for: .touchUpInside)
        authenticateButton.addTarget(self, action: #selector(toAuthentication), for: .touchUpInside)
        urlVerificationButton.addTarget(self, action: #selector(toURLVerification), for: .touchUpInside)
        
        let title = UILabel().wrap().withText(Localized.sdkFunctionalityTitle.string).withFont(Fonts.largeTitle)
        let detail = UILabel().wrap().withText(Localized.sdkFunctionalityText.string).withFont(Fonts.title2)
        
        let stack = UIStackView(arrangedSubviews: [
            title,
            detail,
            manageCredentialsButton,
            authenticateButton,
            urlVerificationButton,
        ]).vertical()
        stack.setCustomSpacing(Spacing.padding, after: detail)
        stack.alignment = .fill
        
        return stack
    }
    
    private func setUpSupportView() -> View {
        let developerDocsButton = CustomButtonWithLine(title: Localized.developerDocsButton.string)
        let supportButton = CustomButtonWithLine(title: Localized.supportButton.string)
        
        developerDocsButton.addTarget(self, action: #selector(toDeveloperDocs), for: .touchUpInside)
        supportButton.addTarget(self, action: #selector(toSupportPage), for: .touchUpInside)
        
        let title = UILabel().wrap().withText(Localized.supportTitle.string).withFont(Fonts.largeTitle)
        let detail = UILabel().wrap().withText(Localized.supportText.string).withFont(Fonts.title2)
        
        let stack = UIStackView(arrangedSubviews: [
            title,
            detail,
            developerDocsButton,
            supportButton,
        ]).vertical()
        
        stack.setCustomSpacing(Spacing.padding, after: detail)
        stack.alignment = .fill
        
        return stack
    }
    
    @objc func toAuthentication() {
        navigationController?.pushViewController(AuthenticationViewController(viewModel: viewModel), animated: true)
    }
    
    @objc func toManageCredentials() {
        navigationController?.pushViewController(ManageCredentialsViewController(viewModel: viewModel), animated: true)
    }
    
    @objc func toURLVerification(){
        navigationController?.pushViewController(URLVerificationViewController(viewModel: viewModel), animated: true)
    }
    
    @objc func toDeveloperDocs() {
        navigationController?.pushViewController(DeveloperDocsViewController(viewModel: viewModel), animated: true)
    }
    
    @objc func toSupportPage() {
        navigationController?.pushViewController(SupportPageViewController(viewModel: viewModel), animated: true)
    }
}
