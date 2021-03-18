import Foundation
import UIKit

extension UIColor {
    static let primaryButtonText = getColor(for: "primaryButtonText")
    static let primaryButtonColor = getColor(for: "primaryButtonColor")
    static let secondaryButtonText = getColor(for: "secondaryButtonText")
    static let secondaryButtonColor = getColor(for: "secondaryButtonColor")

    static func getColor(for name: String) -> UIColor {
        UIColor(named: name, in: Bundle.module, compatibleWith: nil)!
    }
}
