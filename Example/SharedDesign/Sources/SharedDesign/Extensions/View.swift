#if os(iOS)
import UIKit

extension UIView {
    public func addBottomBorder(
        color: Color = Colors.line.value,
        borderWidth: CGFloat = 1)
    {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        layer.addSublayer(border)
    }
}
#endif
