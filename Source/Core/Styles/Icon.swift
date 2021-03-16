import Foundation
import UIKit

extension UIImage {
    static let logo = getIcon(for: "logo")
    static let arrowRight = getIcon(for: "arrowRight")
    
    static func getIcon(for name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle.module, compatibleWith: nil) ?? nil
    }
}

