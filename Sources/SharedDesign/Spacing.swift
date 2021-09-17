#if os(iOS)
import UIKit

public struct Spacing {
    /// between icon and text 4
    public static let small: CGFloat = 4
    /// between buttons, icons, text inside menu items, between text and checkbox, radio button and switch 8
    public static let medium: CGFloat = 8
    /// notification padding, between inputs in forms 16
    public static let large: CGFloat = 16
    /// basic padding 24
    public static let padding: CGFloat = 24
    /// section padding 48
    public static let section: CGFloat = 48
    
    /// how far from the top of the screen
    public static func offsetFromTop(_ view: UIView) -> CGFloat {
        view.bounds.height / 10
    }
}

extension UIView {
    public enum CornerRadiusSize: CGFloat {
        case small = 6
        case medium = 8
        case camera = 32
    }
    public func setCornerRadius(for size: CornerRadiusSize) {
        layer.cornerRadius = size.rawValue
    }
}
#endif

