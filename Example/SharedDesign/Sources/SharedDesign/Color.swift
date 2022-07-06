import Foundation

public enum Colors: String, CaseIterable {
    // MARK: SDK Colors:

    /// #FFFFFF / #1C1C1C
    case background = "background"
    
    /// #DDDDDD / #595959
    case border = "border"
    
    /// #000000 / #FFFFFF (only used on BeyondIdentityButton & QR code scanner)
    case border2 = "border2"
    
    /// #D22121 / #D22121 dark red in darkmode used on icons and buttons
    case danger = "danger"
    
    /// #FFECEC / #FFECEC
    case dangerSurface = "dangerSurface"
    
    /// #3C3C43 with opacity 30% / #FFFFFF
    case disclosure = "disclosure"
    
    /// #000000 / #FFFFFF (part of the select account button arrow)
    case disclosure2 = "disclosure2"
    
    /// #E3E3E4 / #444444
    case empty = "empty"
    
    /// #595959 / #A6A6A6
    case emptyText = "emptyText"

    /// #D22121 / #E57A7A lighter red in darkmode used on error messaged
    case error = "error"
    
    /// #DDDDDD / #444444
    case line = "line"
    
    /// #346EEE / #1C88EC
    case link = "link"
    
    /// #000000 / #FFFFFF
    case navBarText = "navBarText"
    
    /// #4673D3 / #4673D3
    case primary = "primary"
    
    ///  #000000 / #DDDDD both with opacity 25%
    case shadow = "shadow"
    
    /// #FFFFFF / #FFFFFF
    case standardButtonText = "standard-button-text"
    
    /// #333333 / #FFFFFF most instances of text
    case text = "text"

    // MARK: Example App Colors:
    
    /// #F7F7F7 / #333333
    case cardBackground = "cardBackground"

    public var value: Color {
        Colors.getColor(for: self.rawValue)!
    }
    
    static func getColor(for name: String) -> Color? {
        #if os(iOS)
        return Color(named: name, in: Bundle.module, compatibleWith: nil)
        #elseif os(macOS)
        return Color(named: name, bundle: Bundle.module)
        #endif
    }
}
