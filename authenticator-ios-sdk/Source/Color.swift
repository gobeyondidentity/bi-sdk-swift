import Foundation
import UIKit

extension UIColor {
    static var primaryButtonText = getColor(for: "primaryButtonText")
    static var primaryButtonColor = getColor(for: "primaryButtonColor")
    static var secondaryButtonText = getColor(for: "secondaryButtonText")
    static var secondaryButtonColor = getColor(for: "secondaryButtonColor")
    
    static func getColor(for name: String) -> UIColor {
        UIColor(named: name, in: Bundle.sdk, compatibleWith: nil)!
    }
}

