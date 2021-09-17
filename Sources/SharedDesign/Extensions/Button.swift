#if os(iOS)
import UIKit

extension UIButton {
    public func wrap() -> UIButton {
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = .byWordWrapping
        return self
    }
}
#endif
