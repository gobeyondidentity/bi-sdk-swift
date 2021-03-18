import XCTest
@testable import BISDK

class ColorTests: XCTestCase {
    func test_primaryButtonText_notEmpty() throws {
        _ = try XCTUnwrap(UIColor.primaryButtonText)
    }

    func test_primaryButtonColor_notEmpty() throws {
        _ = try XCTUnwrap(UIColor.primaryButtonColor)
    }

    func test_secondaryButtonText_notEmpty() throws {
        _ = try XCTUnwrap(UIColor.secondaryButtonText)
    }

    func test_secondaryButtonColor_notEmpty() throws {
        _ = try XCTUnwrap(UIColor.secondaryButtonColor)
    }
}
