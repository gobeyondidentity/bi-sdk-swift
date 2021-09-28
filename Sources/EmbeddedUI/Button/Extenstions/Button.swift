import SharedDesign

#if os(iOS)
import UIKit

extension Button {
    func setTappableText(text: String, tappableText: String) {
        let tappableAttributes : [ NSAttributedString.Key : Any ] = [
            .foregroundColor: Colors.link.value,
            .font: Fonts.caption
        ]
        let tappable = NSAttributedString(string: tappableText, attributes: tappableAttributes)
        
        let message = NSMutableAttributedString(string: text + " ")
        let messageRange = NSRange(location: 0, length: message.length)
        message.addAttribute(.foregroundColor, value: Colors.body.value, range: messageRange)
        message.addAttribute(.font, value: Fonts.caption, range: messageRange)

        message.append(tappable)
        
        setAttributedTitle(message, for: .normal)
        backgroundColor = Colors.background.value
    }
}
#endif
