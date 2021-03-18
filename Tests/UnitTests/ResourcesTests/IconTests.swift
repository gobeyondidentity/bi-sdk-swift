import XCTest
@testable import BISDK

class IconTests: XCTestCase {
    func test_arrowRight_notEmpty() throws {
        _ = try XCTUnwrap(UIImage.arrowRight)
    }

    func test_logo_notEmpty() throws {
        _ = try XCTUnwrap(UIImage.logo)
    }
}