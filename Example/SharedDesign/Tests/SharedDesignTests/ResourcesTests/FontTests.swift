import XCTest
@testable import SharedDesign

class FontTests: XCTestCase {
    override func setUp() {
        Fonts.isLoaded = false

        super.setUp()
    }

    override func tearDown() {
        Fonts.isLoaded = false
        super.tearDown()
    }
    
    func test_fonts_loadOnce_whenFirstAccessed() {
        XCTAssertFalse(Fonts.isLoaded, "precondition")
        let _ = Fonts.title
        
        XCTAssertTrue(Fonts.isLoaded)
        
        let _ = Fonts.caption
        XCTAssertTrue(Fonts.isLoaded)
    }
    
    func test_allOverpassFonts_load() throws {
        for file in OverpassFontFiles.allCases {
            Fonts.loadFont(from: file.rawValue, in: .module)
        }
        
        XCTAssertTrue(UIFont.familyNames.contains("Overpass"))
        XCTAssertTrue(UIFont.familyNames.contains("Overpass Mono"))

        let names = UIFont.fontNames(forFamilyName: "Overpass") + UIFont.fontNames(forFamilyName: "Overpass Mono")

        for name in OverpassFontNames.allCases {
            XCTAssertTrue(names.contains(name.rawValue), "\(name.rawValue) not found")
        }

    }
    
    
}
