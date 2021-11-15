@testable import BeyondIdentityEmbedded
 import XCTest

class QRCodeTests: XCTestCase {

    func test_generateQRCode_isNotNil_with9DigitToken() {
        let image = generateQRCode(from: CredentialToken(value: "123456789"))
        XCTAssertNotNil(image)
    }

}
