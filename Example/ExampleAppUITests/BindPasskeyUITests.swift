import XCTest

final class BindPasskeyUITests: XCTestCase {
    
    private static let bindPasskeyButton = "Bind Passkey"
    private static let recoverPasskeyButton = "Recover Passkey"
    private static let bindPasskeyTextField = "Unique Username"
    private static let recoverPasskeyTextField = "Username"
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    static public func bindOneNewUser(_ date: String = getCurrentDate()) {
        let app = navigateToSDK()
        
        let usernameField = app.textFields[BindPasskeyUITests.bindPasskeyTextField]
        XCTAssertTrue(usernameField.exists)
        usernameField.waitUntilExists().tap()
        waitUntilElementHasFocus(element: usernameField).typeText(date)
        
        let button = app.buttons[bindPasskeyButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: bindPasskeyButton)
        XCTAssertTrue(responseLabel.exists)
        
        responseExpecting("    username: \(date)", from: responseLabel, { _ in })
    }
    
    static public func recoverExistingUser(_ username: String) {
        let app = navigateToSDK()
        app.swipeUp()
        
        let usernameField = app.textFields[BindPasskeyUITests.recoverPasskeyTextField]
        XCTAssertTrue(usernameField.exists)
        usernameField.waitUntilExists().doubleTap()
        waitUntilElementHasFocus(element: usernameField).typeText(username)
        
        let button = app.buttons[recoverPasskeyButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: recoverPasskeyButton)
        XCTAssertTrue(responseLabel.exists)
        
        responseExpecting("    username: \(username)", from: responseLabel, { _ in })
    }
    
    func testCreateNewUserBindsPasskey() throws {
        BindPasskeyUITests.bindOneNewUser()
    }
    
    func testRecoverExistingUserOverwritesExisitingPasskeyForSameUser() throws {
        let app = navigateToSDK()
        app.swipeUp()
        
        let usernameField = app.textFields[BindPasskeyUITests.recoverPasskeyTextField]
        XCTAssertTrue(usernameField.exists)
        usernameField.waitUntilExists().doubleTap()
        waitUntilElementHasFocus(element: usernameField).typeText(existingUsername)
        
        let button = app.buttons[BindPasskeyUITests.recoverPasskeyButton]
        XCTAssertTrue(button.exists)
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: BindPasskeyUITests.recoverPasskeyButton)
        XCTAssertTrue(responseLabel.exists)
        
        var firstId = ""
        var secondId = ""
        
        button.tap()
        
        responseExpecting("    username: \(existingUsername)", from: responseLabel) { response in
            let passkeyIds = getPasskeyIds(from: response)
            guard passkeyIds.count == 1 else {
                XCTFail("Should only have one passkey id but got: \(passkeyIds)")
                return
            }
            firstId = passkeyIds.first ?? ""
            button.tap()
            responseExpecting("    username: \(existingUsername)", from: responseLabel) { response in
                let passkeyIds = getPasskeyIds(from: response)
                guard passkeyIds.count == 1 else {
                    XCTFail("Should only have one passkey id but got: \(passkeyIds)")
                    return
                }
                secondId = passkeyIds.first ?? ""
                XCTAssertNotEqual(firstId, secondId)
            }
        }
    }
    
    func testCreateUserWithExistingUserErrors() throws {
        let app = navigateToSDK()
        
        let usernameField = app.textFields[BindPasskeyUITests.bindPasskeyTextField]
        XCTAssertTrue(usernameField.exists)
        usernameField.waitUntilExists().tap()
        waitUntilElementHasFocus(element: usernameField).typeText(existingUsername)
        
        let button = app.buttons[BindPasskeyUITests.bindPasskeyButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: BindPasskeyUITests.bindPasskeyButton)
        XCTAssertTrue(responseLabel.exists)
        
        responseExpecting("username already exists", from: responseLabel, { _ in })
    }
    
    func testCreateEmptyUserErrors() throws {
        let app = navigateToSDK()
        
        let usernameField = app.textFields[BindPasskeyUITests.bindPasskeyTextField]
        XCTAssertTrue(usernameField.exists)
        usernameField.waitUntilExists().tap()
        waitUntilElementHasFocus(element: usernameField).typeText("")
        
        let button = app.buttons[BindPasskeyUITests.bindPasskeyButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: BindPasskeyUITests.bindPasskeyButton)
        XCTAssertTrue(responseLabel.exists)
        
        responseExpecting("Please enter a username", from: responseLabel, { _ in })
    }
    
    func testRecoverExistingUserBindsPasskey() throws {
        BindPasskeyUITests.recoverExistingUser(existingUsername)
    }
    
    func testRecoverNonExistingUserBindsErrors() throws {
        let app = navigateToSDK()
        app.swipeUp()
        
        let usernameField = app.textFields[BindPasskeyUITests.recoverPasskeyTextField]
        XCTAssertTrue(usernameField.exists)
        usernameField.waitUntilExists().tap()
        waitUntilElementHasFocus(element: usernameField).typeText(getCurrentDate())
        
        let button = app.buttons[BindPasskeyUITests.recoverPasskeyButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: BindPasskeyUITests.recoverPasskeyButton)
        XCTAssertTrue(responseLabel.exists)
        
        responseExpecting("identity not found", from: responseLabel, { _ in })
    }
}
