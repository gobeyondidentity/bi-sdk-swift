import SharedDesign

#if os(iOS)
import UIKit

class TextFieldWithPadding: TextField {
    var textPadding = EdgeInsets(
        top: Spacing.medium,
        left: Spacing.medium,
        bottom: Spacing.medium,
        right: Spacing.medium
    )
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
#endif
