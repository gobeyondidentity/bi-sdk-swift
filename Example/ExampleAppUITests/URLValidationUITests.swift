import XCTest

final class URLValidationUITests: XCTestCase {
    
    private let emptyResponse = "Please enter a URL first"
    private let notValidResponse = "false"
    private let validResponse = "true"
    
    private let authenticateURLButton = "Validate Authenticate URL"
    private let authenticateTextField = "Authenticate URL"
    
    private let bindPasskeyURLButton = "Validate Bind Passkey URL"
    private let bindPasskeyTextField = "Bind Passkey URL"
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testAuthenticatURLEmpty() throws {
        let app = navigateToURLValidation()
        
        let textField = app.textFields[authenticateTextField]
        XCTAssertTrue(textField.exists)
        
        let button = app.buttons[authenticateURLButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: authenticateURLButton)
        XCTAssertTrue(responseLabel.exists)
        
        responseExpecting(emptyResponse, from: responseLabel, { _ in })
    }
    
    func testAuthenticatURLInvalid() throws {
        let app = navigateToURLValidation()
        
        let textField = app.textFields[authenticateTextField]
        XCTAssertTrue(textField.exists)
        textField.waitUntilExists().tap()
        waitUntilElementHasFocus(element: textField).typeText("notAValidURL.com")
        
        let button = app.buttons[authenticateURLButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: authenticateURLButton)
        XCTAssertTrue(responseLabel.exists)
        
        responseExpecting(notValidResponse, from: responseLabel, { _ in })
    }
    
    func testAuthenticatURLIsValid() throws {
        let app = navigateToURLValidation()
        
        let textField = app.textFields[authenticateTextField]
        XCTAssertTrue(textField.exists)
        textField.waitUntilExists().tap()
        waitUntilElementHasFocus(element: textField).typeText("https://auth-us.beyondidentity.com/bi-authenticate?request=0123456789ABCDEF")
        
        let button = app.buttons[authenticateURLButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: authenticateURLButton)
        XCTAssertTrue(responseLabel.exists)
        
        responseExpecting(validResponse, from: responseLabel, { _ in })
    }
    
    func testBindPasskeyURLEmpty() throws {
        let app = navigateToURLValidation()
        
        let textField = app.textFields[bindPasskeyTextField]
        XCTAssertTrue(textField.exists)
        
        let button = app.buttons[bindPasskeyURLButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: bindPasskeyURLButton)
        XCTAssertTrue(responseLabel.exists)
        
        responseExpecting(emptyResponse, from: responseLabel, { _ in })
    }
    
    func testBindPasskeyURLInvalid() throws {
        let app = navigateToURLValidation()
        
        let textField = app.textFields[bindPasskeyTextField]
        XCTAssertTrue(textField.exists)
        textField.waitUntilExists().tap()
        waitUntilElementHasFocus(element: textField).typeText("notAValidURL.com")
        
        let button = app.buttons[bindPasskeyURLButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: bindPasskeyURLButton)
        XCTAssertTrue(responseLabel.exists)
        
        responseExpecting(notValidResponse, from: responseLabel, { _ in })
    }
    
    func testBindPasskeyURLIsValid() throws {
        let app = navigateToURLValidation()
        
        let textField = app.textFields[bindPasskeyTextField]
        XCTAssertTrue(textField.exists)
        textField.waitUntilExists().tap()
        waitUntilElementHasFocus(element: textField).typeText("https://auth-us.beyondidentity.com/v1/tenants/0123456789ABCDEF/realms/0123456789ABCDEF/identities/0123456789ABCDEF/credential-binding-jobs/01234567-89AB-CDEF-0123-456789ABCDEF:invokeAuthenticator?token=0123456789ABCDEF")
        
        let button = app.buttons[bindPasskeyURLButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: bindPasskeyURLButton)
        XCTAssertTrue(responseLabel.exists)
        
        responseExpecting(validResponse, from: responseLabel, { _ in })
    }
    
}
