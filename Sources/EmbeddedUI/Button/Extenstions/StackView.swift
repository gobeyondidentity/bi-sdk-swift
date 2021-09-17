import SharedDesign

#if os(iOS)
import UIKit

extension UIStackView {
    func withMargin(margin: CGFloat){
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    func withMargin(vertical: CGFloat, horizontal: CGFloat){
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}
#endif
