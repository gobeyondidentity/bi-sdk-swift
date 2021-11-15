import XCTest
@testable import BeyondIdentityAuthenticator
@testable import SharedDesign

class SignUpButtonTests: XCTestCase {
    private var button: SignUpButton!

    override func setUp() {
        super.setUp()
        button = SignUpButton(title: "Sign Up")
    }

    override func tearDown() {
        button = nil
        super.tearDown()
    }

    func test_signUpButton_isAccessible() {
        XCTAssertTrue(button.isAccessibilityElement)
    }

    func test_signUpButton_accessibilityTraits() {
        XCTAssertEqual(button.accessibilityTraits, .button)
    }

    func test_signUpButton_accessibilityLabel_isButtonTitle() {
        XCTAssertEqual(button.accessibilityLabel, "Sign Up")
    }

    func test_signUpButton_color_isSecondaryButtonColor() {
        XCTAssertEqual(button.layer.backgroundColor, UIColor.secondaryButtonColor.cgColor)
    }

    func test_signUpButton_borderColor_isSecondaryButtonText() {
        XCTAssertEqual(button.layer.borderColor, UIColor.secondaryButtonText.cgColor)
    }

    func test_signUpButton_textColor_isSecondaryButtonText() {
        XCTAssertEqual(button.label.textColor, .secondaryButtonText)
    }

    func test_signUpButton_fontTextStyle_isBody() {
        XCTAssertEqual(button.label.font, Fonts.body)
    }
}
