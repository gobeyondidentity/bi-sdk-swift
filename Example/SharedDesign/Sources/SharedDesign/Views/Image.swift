#if os(iOS)
import UIKit

extension UIImageView {
  public func setImageColor(color: Color) {
    let templateImage = image?.withRenderingMode(.alwaysTemplate)
    image = templateImage
    tintColor = color
  }
}
#endif
