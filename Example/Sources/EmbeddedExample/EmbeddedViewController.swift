import BeyondIdentityEmbedded
import UIKit
import Anchorage

class EmbeddedViewController: ScrollableViewController {
    let viewModel: EmbeddedViewModel

    lazy var manageCredentialsButton: CustomButtonWithLine = {
        let button = CustomButtonWithLine(title: Localized.manageCredentialsButton.string)
        return button
    }()
    lazy var extendCredentialsButton: CustomButtonWithLine = {
        let button = CustomButtonWithLine(title: Localized.extendCredentialsButton.string)
        return button
    }()
    lazy var authenticateButton: CustomButtonWithLine = {
        let button = CustomButtonWithLine(title: Localized.authenticateButton.string)
        return button
    }()

    lazy var developerDocsButton: CustomButtonWithLine = {
        let button = CustomButtonWithLine(title: Localized.developerDocsButton.string)
        return button
    }()

    lazy var supportButton: CustomButtonWithLine = {
        let button = CustomButtonWithLine(title: Localized.supportButton.string)
        return button
    }()

    let createUserEmailField = UITextField().with(placeholder: Localized.createUserEmailField.string, type: .emailAddress)
    var createUserEmail: String?
    let createUserButton = makeButton(with: Localized.createUserButton.string)
    let createUserLabel = UILabel().wrap()

    init(viewModel: EmbeddedViewModel) {
        self.viewModel = viewModel
        super.init()
        let imageView = UIImageView(image: .vector)
        navigationItem.titleView = imageView
        view.backgroundColor = UIColor(named: Colors.nuetralGrey.rawValue)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedOutside()

        manageCredentialsButton.addTarget(self, action: #selector(toManageCredentials), for: .touchUpInside)
        extendCredentialsButton.addTarget(self, action: #selector(toExtendCredentials), for: .touchUpInside)
        authenticateButton.addTarget(self, action: #selector(toAuthentication), for: .touchUpInside)
        developerDocsButton.addTarget(self, action: #selector(toDeveloperDocs), for: .touchUpInside)
        supportButton.addTarget(self, action: #selector(toSupportPage), for: .touchUpInside)
        createUserButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        createUserEmailField.addTarget(self, action: #selector(createUserEmailFieldDidChange(_:)), for: .editingChanged)
        createUserEmailField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEndOnExit)

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        let recoverView = RecoveryView(recoveryURL: viewModel.recoverUserEndpoint, for: self)

        setUpScrollView()

        let viewEmbeddedSdkTitle = UILabel().wrap().withTitle(Localized.viewEmbeddedSdkTitle.string).withFont(UIFont(name: OverpassFontNames.bold.rawValue, size: Size.largeTitle) ??  UIFont.systemFont(ofSize: Size.largeTitle))
        let sdkVersion = UILabel().wrap().withTitle("Version: \(EmbeddedViewModel().sdkVersion)").withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.medium) ??  UIFont.systemFont(ofSize: Size.medium))
        let getStartedTitle = UILabel().wrap().withTitle(Localized.getStartedTitle.string).withFont(UIFont(name: OverpassFontNames.bold.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))
        let registerTitle = UILabel().wrap().withTitle(Localized.registerTitle.string).withFont(UIFont(name: OverpassFontNames.bold.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))
        let registerText = UILabel().wrap().withTitle(Localized.registerText.string).withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))
        let recoverTitle = UILabel().wrap().withTitle(Localized.recoverTitle.string).withFont(UIFont(name: OverpassFontNames.bold.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))
        let recoverText = UILabel().wrap().withTitle(Localized.recoverText.string).withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))
        let recoverNote = UILabel().wrap().withTitle(Localized.recoverNote.string).withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large))

        let stackEmbeddedSdk = UIStackView(arrangedSubviews: [
            viewEmbeddedSdkTitle,
            sdkVersion,
            getStartedTitle,
            registerTitle,
            registerText,
            createUserEmailField,
            createUserButton,
            createUserLabel,
            recoverTitle,
            recoverText,
            recoverNote,
            recoverView
        ]).vertical()

        let sdkFunctionalityTitle = UILabel().wrap().withTitle(Localized.sdkFunctionalityTitle.string).withFont(UIFont(name: OverpassFontNames.bold.rawValue, size: Size.largeTitle) ??  UIFont.systemFont(ofSize: Size.largeTitle))

        let stackSdkFunctionality = UIStackView(arrangedSubviews: [
            sdkFunctionalityTitle,
            UILabel().wrap().withTitle(Localized.sdkFunctionalityText.string).withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large)),
            manageCredentialsButton,
            extendCredentialsButton,
            authenticateButton,
        ]).vertical()

        let supportTitle =  UILabel().wrap().withTitle(Localized.supportTitle.string).withFont(UIFont(name: OverpassFontNames.bold.rawValue, size: Size.largeTitle) ??  UIFont.systemFont(ofSize: Size.largeTitle))

        let stackSdkSupport = UIStackView(arrangedSubviews: [
            supportTitle,
            UILabel().wrap().withTitle(Localized.supportText.string).withFont(UIFont(name: OverpassFontNames.regular.rawValue, size: Size.large) ??  UIFont.systemFont(ofSize: Size.large)),
            developerDocsButton,
            supportButton,
        ]).vertical()

        let embeddedContainer = UIStackView(arrangedSubviews: [
            stackEmbeddedSdk,
        ]).vertical()

        let sdkFunctionalityContainer = UIStackView(arrangedSubviews: [
            stackSdkFunctionality,
        ]).vertical()

        let supportContainer = UIStackView(arrangedSubviews: [
            stackSdkSupport,
        ]).vertical()


        let stack = UIStackView(arrangedSubviews: [
            embeddedContainer,
            sdkFunctionalityContainer,
            supportContainer,
        ]).vertical()

        contentView.addSubview(stack)
        contentView.backgroundColor = UIColor(named: Colors.nuetralGrey.rawValue)

        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors
        stack.verticalAnchors == contentView.safeAreaLayoutGuide.verticalAnchors
        stack.alignment = .fill

        embeddedContainer.backgroundColor = UIColor(named: Colors.background.rawValue)
        embeddedContainer.isLayoutMarginsRelativeArrangement = true
        embeddedContainer.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        stack.setCustomSpacing(16, after: embeddedContainer)
        stackEmbeddedSdk.setCustomSpacing(32, after: sdkVersion)
        stackEmbeddedSdk.setCustomSpacing(32, after: createUserLabel)
        stackEmbeddedSdk.setCustomSpacing(16, after: recoverText)
        stackEmbeddedSdk.alignment = .fill

        sdkFunctionalityContainer.backgroundColor = UIColor(named: Colors.background.rawValue)
        sdkFunctionalityContainer.isLayoutMarginsRelativeArrangement = true
        sdkFunctionalityContainer.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 15, trailing: 5)
        stackSdkFunctionality.alignment = .fill
        stack.setCustomSpacing(16, after: sdkFunctionalityContainer)

        supportContainer.backgroundColor = UIColor(named: Colors.background.rawValue)
        supportContainer.isLayoutMarginsRelativeArrangement = true
        supportContainer.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 5)
        stackSdkSupport.alignment = .fill
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc func createUser() {
        guard let email = createUserEmail, email.contains("@") else {
            createUserLabel.text = "enter an email first"
            return
        }
        signUpAction(email)
    }
    
    func signUpAction(_ email: String) {
        send(for: self, with: createRequest(with: email))
    }
    
    func createRequest(with email: String) -> URLRequest {
        var request = URLRequest(url: viewModel.registrationEndpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "binding_token_delivery_method": "email",
            "external_id" : email,
            "email" : email,
            "user_name" : email,
            "display_name" : email
        ]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        request.httpBody = bodyData
        
        return request
    }
    
    @objc func createUserEmailFieldDidChange(_ textField: UITextField) {
        if let input = textField.text, !input.isEmpty {
            createUserEmail = input
        }
    }
    
    @objc func textFieldDidEnd(_ textField: UITextField) {
        textField.resignFirstResponder()
        createUser()
    }
    
    @objc func toAuthentication() {
        navigationController?.pushViewController(AuthenticationViewController(viewModel: viewModel), animated: true)
    }
    
    @objc func toExtendCredentials() {
        navigationController?.pushViewController(ExtendCredentialsViewController(viewModel: viewModel), animated: true)
    }
    
    @objc func toManageCredentials() {
        navigationController?.pushViewController(ManageCredentialsViewController(viewModel: viewModel), animated: true)
    }

    @objc func toDeveloperDocs() {
        navigationController?.pushViewController(DeveloperDocsViewController(viewModel: viewModel), animated: true)
    }

    @objc func toSupportPage() {
        navigationController?.pushViewController(SupportPageViewController(viewModel: viewModel), animated: true)
    }

}
