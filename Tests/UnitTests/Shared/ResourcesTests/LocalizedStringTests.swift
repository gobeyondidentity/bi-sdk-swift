import XCTest
@testable import SharedDesign

class LocalizedStringTests: XCTestCase {
    func test_allCases() {
        LocalizedString.allCases.forEach({ key in
            XCTAssertNotEqual(key.string, "not found", "for \(key.rawValue)")
        })
    }
}
