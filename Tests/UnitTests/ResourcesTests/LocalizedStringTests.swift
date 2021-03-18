import XCTest
@testable import BISDK

class LocalizedStringTests: XCTestCase {
    func test_allCases() {
        LocalizedString.allCases.forEach({ string in
            XCTAssertNotEqual(LocalizedString.value(for: string), "not found", "for \(string.rawValue)")
        })
    }
}