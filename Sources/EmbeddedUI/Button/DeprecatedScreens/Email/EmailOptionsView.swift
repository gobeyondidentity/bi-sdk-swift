//import SharedDesign
//
//#if os(iOS)
//import UIKit
//#elseif os(macOS)
//import Cocoa
//#endif
//
//struct EmailOptionsView {
//    let actionSheet: Alert
//    
//    /// Create an Action Sheet displaying multiple email options.
//    /// - Parameter emailTo: if provided then tapping on an action will open to compose a message with the email address provided, if not provided then tapping on an action will just open the mail client
//    #if os(iOS)
//    init() {
//        actionSheet = Alert(title: LocalizedString.emailOptionsTitle.string, message: LocalizedString.emailOptionsDescription.string, preferredStyle: .actionSheet)
//        
//        let actions = [
//            mailAction(),
//            gmailAction(),
//            yahooAction(),
//            outlookAction()
//        ]
//        
//        actions.forEach{ $0.map(actionSheet.addAction) }
//        actionSheet.addAction(UIAlertAction(title: LocalizedString.emailOptionsCancelButton.string, style: .cancel, handler: nil))
//    }
//    
//    public func show(with vc: ViewController) {
//        // if nothing to show but cancel button, then don't present this actionSheet
//        guard actionSheet.actions.count > 1 else { return }
//        vc.present(actionSheet, animated: true, completion: nil)
//    }
//    
//    
//    private func gmailAction() -> UIAlertAction? {
//        return makeAction(with: "googlegmail://", title: LocalizedString.emailOptionsGmail.string)
//    }
//    
//    private func mailAction() -> UIAlertAction? {
//        // mailto: will always direct to a composition screen where message:// will just open the application
//        return makeAction(with: "message://", title: LocalizedString.emailOptionsAppleMail.string)
//    }
//    
//    private func outlookAction() -> UIAlertAction? {
//        return makeAction(with: "ms-outlook://", title: LocalizedString.emailOptionsOutlook.string)
//    }
//    
//    private func yahooAction() -> UIAlertAction? {        
//        return makeAction(with: "ymail://", title: LocalizedString.emailOptionsYahoo.string)
//    }
//    
//    /// Make UIAlertActions
//    private func makeAction(with url: String, title: String) -> UIAlertAction? {
//        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
//            return nil
//        }
//        let action = UIAlertAction(title: title, style: .default) { (action) in
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//        return action
//    }
//    #endif
//}
//
