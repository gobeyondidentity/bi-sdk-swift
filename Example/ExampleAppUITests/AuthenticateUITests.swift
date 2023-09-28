import XCTest

final class AuthenticateUITests: XCTestCase {
    private let beyondIdentityButton = "Authenticate with Beyond Identity"
    private let auth0Button = "Authenticate with Auth0"
    private let oktaButton = "Authenticate with Okta"
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testAuthenticateWithBeyondIdentityMultiplePasskeysWithPrompt() throws {
        let usernameOne = getCurrentDate()
        
        BindPasskeyUITests.bindOneNewUser(usernameOne)
        BindPasskeyUITests.recoverExistingUser(existingUsername)
        
        let app = navigateToAuthenticate()
        
        
        let button = app.buttons[beyondIdentityButton]
        XCTAssertTrue(button.exists)
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: beyondIdentityButton)
        XCTAssertTrue(responseLabel.exists)
        
        button.tap()
        
        let promptView = app.otherElements["PasskeyModal"]
        
        if promptView.waitForExistence(timeout: 10) {
            print(promptView.debugDescription)
            let userOne = promptView.buttons.containing(.staticText, identifier:"display_name_\(usernameOne)").element
            XCTAssertTrue(userOne.exists)
            
            let userTwo = promptView.buttons.containing(.staticText, identifier:"display_name_\(existingUsername)").element
            XCTAssertTrue(userTwo.exists)
            
            userOne.tap()
        } else {
            XCTFail("promptView is missing")
        }
        
        getResponseValue(3.0, from: responseLabel) { response in
            XCTAssertTrue(response.contains("accessToken:"), "Got: \(response)")
        }
    }
    
    func testAuthenticateWithBeyondIdentitySinglePasskeyWithoutPrompt() throws {
        PasskeyManagementUITests.clearAllPasskeys()
        BindPasskeyUITests.recoverExistingUser(existingUsername)
        
        let app = navigateToAuthenticate()
        
        let button = app.buttons[beyondIdentityButton]
        XCTAssertTrue(button.exists)
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: beyondIdentityButton)
        XCTAssertTrue(responseLabel.exists)
        
        button.tap()
        
        getResponseValue(3.0, from: responseLabel) { response in
            XCTAssertTrue(response.contains("accessToken:"), "Got: \(response)")
        }
    }
    
    func testAuthenticateWithAuth0SinglePasskeyWithoutPrompt() throws {
        PasskeyManagementUITests.clearAllPasskeys()
        BindPasskeyUITests.recoverExistingUser(existingUsername)
        
        let app = navigateToAuthenticate()
        
        let button = app.buttons[auth0Button]
        XCTAssertTrue(button.exists)
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: auth0Button)
        XCTAssertTrue(responseLabel.exists)
        
        button.tap()
        
        let alertDescription = "“ExampleApp” Wants to Use “auth0.com” to Sign In"
        
        addUIInterruptionMonitor(withDescription: alertDescription) { (alert) -> Bool in
            let button = alert.buttons["Continue"]
            XCTAssertTrue(button.exists, "Continue button is missing from alert")
            
            button.tap()
            return true
        }
        
        sleep(5)
        
        app.tap()
        
        sleep(5)
        
        app.tap()
        
        getResponseValue(6.0, from: responseLabel) { response in
            XCTAssertTrue(response.contains("accessToken:"), "Got: \(response)")
        }
    }
    
    func testAuthenticateWithOktaSinglePasskeyWithoutPrompt() throws {
        PasskeyManagementUITests.clearAllPasskeys()
        BindPasskeyUITests.recoverExistingUser("difficult-coat@email.com")
        
        let app = navigateToAuthenticate()
        
        let button = app.buttons[oktaButton]
        XCTAssertTrue(button.exists)
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: oktaButton)
        XCTAssertTrue(responseLabel.exists)
        
        sleep(5)
        
        button.tap()
        
        sleep(5)
        
        let alertDescription = "“ExampleApp” Wants to Use “okta.com” to Sign In"
        
        addUIInterruptionMonitor(withDescription: alertDescription) { (alert) -> Bool in
            let button = alert.buttons["Continue"]
            XCTAssertTrue(button.exists, "Continue button is missing from alert")
            
            button.tap()
            return true
        }
        
        app.tap()
        
        getResponseValue(6.0, from: responseLabel) { response in
            XCTAssertTrue(response.contains("accessToken:"), "Got: \(response)")
        }
    }
}
