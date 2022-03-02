import UIKit

public typealias Image = UIImage

extension Image {
    public static let vector = getIcon(for: "Vector")

    public static func getIcon(for name: String) -> Image? {

        return Image(named: name, in: Bundle.main, compatibleWith: nil) ?? nil

    }
}
