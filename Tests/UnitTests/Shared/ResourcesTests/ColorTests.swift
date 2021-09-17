import XCTest
@testable import SharedDesign

class ColorTests: XCTestCase {
    func test_allColors_notEmpty() throws {
        try Colors.allCases.forEach { color in
            _ = try XCTUnwrap(Colors.getColor(for: color.rawValue),
                              "got nil for \(color)")
        }
    }
}
