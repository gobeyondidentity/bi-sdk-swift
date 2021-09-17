import SharedDesign

#if os(iOS)
import UIKit

enum ShadowBox {
    case signUp
    case loading
    case credentialCard
}

extension UIView {
    func configureWithShadowBorder(for box: ShadowBox = .signUp) {
        layer.masksToBounds = false
        backgroundColor = Colors.background.value
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 8).cgPath
        layer.shadowOpacity = 1
        layer.shadowColor = Colors.shadow.value.cgColor
        layer.bounds = bounds
        layer.position = center
        
        setCornerRadius(for: .medium)
        layer.borderWidth = 1
        
        switch box {
        case .signUp, .loading:
            layer.shadowRadius = 4
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.borderColor = Colors.border.value.cgColor

        case .credentialCard:
            layer.shadowRadius = 2
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.borderColor = Colors.border3.value.cgColor
        }
    }
}

extension UIView {
    func addBottomBorder(color: Color = Colors.border.value, borderWidth: CGFloat = 1) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
    layer.addSublayer(border)
  }
}
#endif

extension View {
    public var parentViewController: ViewController? {
        var parentResponder: Responder? = self
        while parentResponder != nil {
            #if os(iOS)
            parentResponder = parentResponder?.next
            #elseif os(macOS)
            parentResponder = parentResponder?.nextResponder
            #endif
            if let viewController = parentResponder as? ViewController {
                return viewController
            }
        }
        return nil
    }
}
