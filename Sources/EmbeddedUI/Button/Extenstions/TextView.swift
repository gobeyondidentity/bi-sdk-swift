import SharedDesign

#if os(iOS)
import UIKit

extension UITextView {
    enum TappableOption: String {
        case addToDevice
        case recoverAccount
        case visitSupport
    }
    
    func setTappableText(with textViewDelegate: UITextViewDelegate, text: String, tappableText: String, for option: TappableOption){
        let tappableText = NSMutableAttributedString(string: tappableText)
        let tappableTextRange = NSRange(location: 0, length: tappableText.length)
        tappableText.addAttribute(.foregroundColor, value: Colors.link.value, range: tappableTextRange)
        tappableText.addAttribute(.font, value: Fonts.caption, range: tappableTextRange)
        tappableText.addAttribute(.link, value: option.rawValue, range: tappableTextRange)
        
        let message = NSMutableAttributedString(string: text + " ")
        let messageRange = NSRange(location: 0, length: message.length)
        message.addAttribute(.foregroundColor, value: Colors.body.value, range: messageRange)
        message.addAttribute(.font, value: Fonts.caption, range: messageRange)
        message.append(tappableText)
        
        adjustsFontForContentSizeCategory = true
        attributedText = message
        textAlignment = .center
        isEditable = false
        isScrollEnabled = false
        delegate = textViewDelegate
        backgroundColor = Colors.background.value
    }
}
#endif
