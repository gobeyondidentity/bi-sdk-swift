import XCTest
@testable import authenticator_ios_sdk

class IconTests: XCTestCase {
    func test_arrowRight_notEmpty() throws {
        let _ = try XCTUnwrap(UIImage.arrowRight)
    }
    
    func test_logo_notEmpty() throws {
        let _ = try XCTUnwrap(UIImage.logo)
    }
}
