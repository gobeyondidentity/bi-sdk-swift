import XCTest

final class EmailOTPUITests: XCTestCase {
    private let authenticationContextButton = "Authentication Context"
    private let emailOTPButton = "Authenticate with Email OTP"
    private let emailOTPTextField = "Email"
    private let redeemOTPButton = "Redeem with Email OTP"
    private let redeemOTPTextField = "OTP"
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testAuthenticateContext() throws {
        let app = navigateToAuthenticate()
        
        let button = app.buttons[authenticationContextButton]
        XCTAssertTrue(button.exists)
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: authenticationContextButton)
        XCTAssertTrue(responseLabel.exists)
        
        button.tap()
        
        getResponseValue(3.0, from: responseLabel) { response in
            XCTAssertTrue(response.contains("authUrl:"), "Got: \(response)")
        }
    }
    
    func testAuthenticateWithEmailOTPAndRedeemFailedOTP() throws {
        let app = navigateToAuthenticate()
        let email = "a@a.com"
        
        let emailField = app.textFields[emailOTPTextField]
        XCTAssertTrue(emailField.exists)
        emailField.waitUntilExists().doubleTap()
        waitUntilElementHasFocus(element: emailField).typeText(email)
        
        let button = app.buttons[emailOTPButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: emailOTPButton)
        XCTAssertTrue(responseLabel.exists)
        
        getResponseValue(3.0, from: responseLabel) { response in
            XCTAssertTrue(response.contains("url:"), "Got: \(response)")
            
            // Email successfully sent
            // Now testing redeemOTP with fake otp
            // This is expected to fail (unable to check email)
            let incorrectOTP = "12345"
            
            let otpField = app.textFields[redeemOTPTextField]
            XCTAssertTrue(otpField.exists)
            otpField.waitUntilExists().doubleTap()
            waitUntilElementHasFocus(element: otpField).typeText(incorrectOTP)
            
            let redeemButton = app.buttons[redeemOTPButton]
            XCTAssertTrue(redeemButton.exists)
            redeemButton.tap()
            redeemButton.tap()
            
            let redeemResponseLabel = getResponseLabel(from: app, buttonTitle: redeemOTPButton)
            XCTAssertTrue(redeemResponseLabel.exists)
            
            getResponseValue(3.0, from: redeemResponseLabel) { response in
                XCTAssertTrue(response.contains("otp failed:"), "Got: \(response)")
            }
        }
    }
}
