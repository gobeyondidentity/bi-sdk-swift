import XCTest
@testable import SharedDesign

class IconTests: XCTestCase {
    func test_arrowRight_notEmpty() throws {
        _ = try XCTUnwrap(UIImage.arrowRight)
    }

    func test_close_notEmpty() throws {
        _ = try XCTUnwrap(UIImage.close)
    }
    
    func test_chevronRight_notEmpty() throws {
        _ = try XCTUnwrap(UIImage.chevronRight)
    }
    
    func test_error_notEmpty() throws {
        _ = try XCTUnwrap(UIImage.error)
    }
    
    func test_logo_notEmpty() throws {
        _ = try XCTUnwrap(UIImage.logo)
    }
    
    func test_poweredByBILogo_notEmpty() throws {
        _ = try XCTUnwrap(UIImage.poweredByBILogo)
    }
}
