import Foundation

private class BundleLocator: NSObject {}

#if !SWIFT_PACKAGE
extension Bundle {
    static var module: Bundle {
        Bundle(for: BundleLocator.self)
    }
}
#endif