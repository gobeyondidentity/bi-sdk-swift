#if os(iOS)
import UIKit

extension UILabel {
    public func wrap() -> UILabel {
        setWrap()
        return self
    }
    
    public func setWrap() {
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
    
    /// sets `text` and defaults `textColor` to `Colors.body.value`
    public func withText(_ text: String?) -> UILabel {
        setText(text)
        textColor = Colors.text.value
        return self
    }
    
    /// sets `text` and defaults `textColor` to `Colors.body.value`
    public func setText(_ text: String?) {
        self.text = text
    }
    
    public func withFont(_ font: UIFont) -> UILabel {
        setFont(font)
        return self
    }
    
    public func setFont(_ font: UIFont) {
        self.font = font
        adjustsFontForContentSizeCategory = true
    }
    
    public func withColor(_ color: UIColor) -> UILabel {
        textColor = color
        return self
    }
}
#endif
