import Foundation
import UIKit

enum OverpassFontFiles: String, CaseIterable {
    // font file name without extension
    case bold = "overpass-bold"
    case extraBold = "overpass-extrabold"
    case monoRegular = "overpass-mono-regular"
    case regular = "overpass-regular"
}

enum OverpassFontNames: String, CaseIterable {
    // macOS and iOS ingest fonts differently and give them different names.
    #if os(macOS)
    case regular = "Overpass"
    case bold = "Overpass Bold"
    case extraBold = "Overpass ExtraBold"
    case mono = "Overpass Mono"
    #elseif os(iOS)
    case regular = "Overpass-Regular"
    case bold = "Overpass-Bold"
    case extraBold = "Overpass-ExtraBold"
    case mono = "OverpassMono-Regular"
    #endif
}

public struct Fonts {
    static var isLoaded = false
    
    public static let title: Font = scaledFont(.regular, 20)
    public static let title2: Font = scaledFont(.regular, 18)
    public static let navTitle: Font  = scaledFont(.bold, 18)
    public static let body: Font  = scaledFont(.regular, 14)
    public static let caption: Font  = scaledFont(.regular, 12)
    
    static func loadOnce() {
        if !isLoaded {
            for file in OverpassFontFiles.allCases {
                loadFont(from: file.rawValue, in: .module)
            }
            isLoaded = true
        }
    }
    
    private static func scaledFont(_ fontName: OverpassFontNames, _ fontSize: CGFloat) -> Font {
        Fonts.loadOnce()
        let font = Font(name: fontName.rawValue, size: fontSize) ?? Font.systemFont(ofSize: fontSize)
        
        #if os(macOS)
        return font
        #elseif os(iOS)
        return UIFontMetrics.default.scaledFont(for: font)
        #endif
    }
    
    static func loadFont(from fileName: String, in bundle: Bundle) {
        let fontFileURL = URL(fileURLWithPath: bundle.bundlePath).appendingPathComponent(fileName).appendingPathExtension("ttf")
        
        var fontError: Unmanaged<CFError>?
        
        if let fontData = try? Data(contentsOf: fontFileURL) as CFData,
           let dataProvider = CGDataProvider(data: fontData),
           let fontRef = CGFont(dataProvider) {
            if CTFontManagerRegisterGraphicsFont(fontRef, &fontError),
               let postScriptName = fontRef.postScriptName {
                print("Successfully loaded font: '\(postScriptName)'.")
            } else if let fontError = fontError?.takeRetainedValue() {
                let errorDescription = CFErrorCopyDescription(fontError)
                print("Failed to load font '\(fileName)': \(String(describing: errorDescription))")
            }
        } else {
            guard let fontError = fontError?.takeRetainedValue() else {
                print("Failed to load font '\(fileName)'.")
                return
            }
            
            let errorDescription = CFErrorCopyDescription(fontError)
            print("Failed to load font '\(fileName)': \(String(describing: errorDescription))")
        }
    }
}
