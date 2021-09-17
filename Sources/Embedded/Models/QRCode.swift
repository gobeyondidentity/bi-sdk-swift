import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

#if os(iOS)
/// UIImage containing a QRCode
public typealias QRCode = UIImage
#elseif os(macOS)
/// NSImage containing a QRCode
public typealias QRCode = NSImage
#endif

private extension CIFilter {
    static let codeGenerator = CIFilter(name: "CIQRCodeGenerator")
}

private extension String {
    static let filterKey = "inputMessage"
}

private func generate(from string: String) -> CIImage? {
    let data = string.data(using: .isoLatin1, allowLossyConversion: false)

    guard let filter = CIFilter.codeGenerator else { return nil }

    filter.setValue(data, forKey: .filterKey)
    let transform = CGAffineTransform(scaleX: 10, y: 10)

    return filter.outputImage?.transformed(by: transform)
}

#if os(iOS)

/// generate a UIImage QR Code for ios
func generateQRCode(from token: CredentialToken) -> UIImage? {
    guard let ciImage = generate(from: token.value) else { return nil }

    return UIImage(ciImage: ciImage)
}
#elseif os(macOS)

/// generate an NSImage QR Code for mac
func generateQRCode(from token: CredentialToken) -> NSImage? {
    guard let ciImage = generate(from: token.value) else { return nil }

    let rep = NSCIImageRep(ciImage: ciImage)
    let nsImage = NSImage(size: rep.size)
    nsImage.addRepresentation(rep)
    return nsImage
}
#endif
