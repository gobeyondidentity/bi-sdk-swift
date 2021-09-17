import Foundation

extension Image {
    public static let accessDenied = getIcon(for: "access_denied")
    public static let arrowRight = getIcon(for: "arrowRight")
    public static let close = getIcon(for: "close")
    public static let chevronRight = getIcon(for: "chevron-right")
    public static let error = getIcon(for: "errorIcon")
    public static let key = getIcon(for: "key")
    public static let logo = getIcon(for: "logo")
    public static let poweredByBILogo = getIcon(for: "powered-by-bi")
    public static let qrCodeUnavailable = getIcon(for: "qr-unavailable")
    
    public static func getIcon(for name: String) -> Image? {
        #if os(iOS)
        return Image(named: name, in: Bundle.module, compatibleWith: nil) ?? nil
        #elseif os(macOS)
        return Image(named: name)
        #endif
    }
}
