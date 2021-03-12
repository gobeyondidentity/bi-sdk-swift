import Foundation

private class BundleLocator: NSObject {}

extension Bundle {
  static var sdk: Bundle {
    return Bundle(for: BundleLocator.self)
  }
}
