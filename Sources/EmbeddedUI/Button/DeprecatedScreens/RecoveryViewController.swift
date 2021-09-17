//import Anchorage
//import Foundation
//import SharedDesign
//
//#if os(iOS)
//import UIKit
//
//class RecoveryViewController: ScrollableViewController {
//    private var emailForm: EmailFormView
//    private let infoLabel = Label().wrap().withFont(Fonts.body)
//    private let recoverUserToken: String
//    
//    init(appName: String, recoverUserToken: String) {
//        self.recoverUserToken = recoverUserToken
//        emailForm = EmailFormView(for: .recover, token: recoverUserToken, buttonAction: {})
//        infoLabel.text = LocalizedString.recoverDescription.format(appName)
//
//        super.init()
//        title = LocalizedString.recoverScreenTitle.string
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//                
//        setUpHideOpenKeyboardOnTap()
//        
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//        
//        view.backgroundColor = Colors.background.value
//        
//        let errorIcon = ImageView(image: .error)
//        errorIcon.contentMode = .scaleAspectFit
//        
//        infoLabel.textColor = Colors.body.value
//        infoLabel.textAlignment = .center
//                
//        emailForm = EmailFormView(for: .recover, token: recoverUserToken, buttonAction: tapRecover)
//        
//        let stack = StackView(arrangedSubviews: [errorIcon, infoLabel, emailForm])
//        stack.axis = .vertical
//        stack.spacing = Spacing.large
//        
//        contentView.addSubview(stack)
//        
//        stack.topAnchor == contentView.safeAreaLayoutGuide.topAnchor + Spacing.offsetFromTop(view)
//        stack.bottomAnchor <= contentView.safeAreaLayoutGuide.bottomAnchor
//        stack.horizontalAnchors == contentView.safeAreaLayoutGuide.horizontalAnchors + Spacing.padding
//    }
//    
//    private func tapRecover() {
//        let popUpView = PopUpView(
//            title: LocalizedString.emailTitle.string,
////            titleIcon: .mail,
//            info: LocalizedString.emailDescription.string,
//            buttonTitle: LocalizedString.emailInboxPrompt.string,
//            primaryAction: { [weak self] in
//                guard let self = self else { return }
//                self.dismiss(animated: true, completion: nil)
//                EmailOptionsView().show(with: self)
//            },
//            closeAction: { self.dismiss(animated: true, completion: nil) }
//        )
//        
//        self.present(PopUpViewController(popUpView: popUpView), animated: true, completion: nil)
//    }
//    
//    @objc private func adjustForKeyboard(notification: Notification) {
//        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//        
//        let keyboardScreenEndFrame = keyboardValue.cgRectValue
//        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
//        
//        if notification.name == UIResponder.keyboardWillHideNotification {
//            scrollView.contentInset = .zero
//        } else {
//            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
//        }
//        
//        scrollView.scrollIndicatorInsets = scrollView.contentInset
//    }
//    
//    @available(*, unavailable)
//    required init?(coder aDecoder: Coder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//#endif
