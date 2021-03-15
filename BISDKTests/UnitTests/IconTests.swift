import XCTest
@testable import BISDK

class IconTests: XCTestCase {
    func test_arrowRight_notEmpty() throws {
        let _ = try XCTUnwrap(UIImage.arrowRight)
    }
    
    func test_logo_notEmpty() throws {
        let _ = try XCTUnwrap(UIImage.logo)
    }
}
