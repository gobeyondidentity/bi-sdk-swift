#if os(iOS)
import UIKit

extension UIStackView {
    public func withMargin(margin: CGFloat){
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    public func withMargin(vertical: CGFloat, horizontal: CGFloat){
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    public func withMargin(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat){
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    public func withMargin(vertical: CGFloat, left: CGFloat, right: CGFloat){
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: vertical, left: left, bottom: vertical, right: right)
    }
}
#endif
