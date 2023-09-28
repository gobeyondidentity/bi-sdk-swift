import XCTest


final class PasskeyManagementUITests: XCTestCase {
    
    private static let viewPasskeysButton = "View Passkeys"
    private static let deletePasskeyButton = "Delete Passkey"
    
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testViewNoPasskeys() throws {
        PasskeyManagementUITests.clearAllPasskeys()
        
        let app = navigateToManagePasskeys()
        
        let button = app.buttons[PasskeyManagementUITests.viewPasskeysButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: PasskeyManagementUITests.viewPasskeysButton)
        XCTAssertTrue(responseLabel.exists)
        
        responseExpecting(noPasskeyText, from: responseLabel, { _ in })
    }
    
    func testViewOnePasskeys() throws {
        PasskeyManagementUITests.clearAllPasskeys()
        
        BindPasskeyUITests.recoverExistingUser(existingUsername)
        
        let app = navigateToManagePasskeys()
        
        let button = app.buttons[PasskeyManagementUITests.viewPasskeysButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: PasskeyManagementUITests.viewPasskeysButton)
        XCTAssertTrue(responseLabel.exists)
        
        getResponseValue(from: responseLabel) { response in
            if response.contains(noPasskeyText) {
                XCTFail("Should have one passkey but didn't find any.\n Returned: \(response)")
            }
            
            let components = response.components(separatedBy: "\n")
            // get all usernames
            let usernames = components.filter { item in
                item.contains("username:")
            }
            
            XCTAssertEqual(usernames.count, 1)
            XCTAssertTrue(usernames[0].contains("    username: \(existingUsername)"), "Got: \(usernames[0])")
        }
        
    }
    
    func testViewTwoPasskeys() throws {
        PasskeyManagementUITests.clearAllPasskeys()
        
        let usernameOne = getCurrentDate()
        BindPasskeyUITests.bindOneNewUser(usernameOne)
        BindPasskeyUITests.recoverExistingUser(existingUsername)
        
        let app = navigateToManagePasskeys()
        
        let button = app.buttons[PasskeyManagementUITests.viewPasskeysButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: PasskeyManagementUITests.viewPasskeysButton)
        XCTAssertTrue(responseLabel.exists)
        
        getResponseValue(from: responseLabel) { response in
            if response.contains(noPasskeyText) {
                XCTFail("Should have two passkeys but didn't find any.\n Returned: \(response)")
            }
            
            let components = response.components(separatedBy: "\n")
            // get all usernames
            let usernames = components.filter { item in
                item.contains("username:")
            }
            
            XCTAssertEqual(usernames.count, 2)
            XCTAssertTrue(usernames[0].contains("    username: \(usernameOne)"), "Got: \(usernames[0])")
            XCTAssertTrue(usernames[1].contains("    username: \(existingUsername)"), "Got: \(usernames[1])")
        }
    }
    
    func testDeleteWithNoPasskeys() throws {
        PasskeyManagementUITests.clearAllPasskeys()
        
        let app = navigateToManagePasskeys()
        
        let button = app.buttons[PasskeyManagementUITests.deletePasskeyButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: PasskeyManagementUITests.deletePasskeyButton)
        XCTAssertTrue(responseLabel.exists)
        
        responseExpecting("Please enter a passkey ID", from: responseLabel, { _ in })
    }
    
    func testDeleteNonExisitingPasskeysSucceeds() throws {
        PasskeyManagementUITests.deleteOnePasskey(getCurrentDate())
    }
    
    func testDeleteAtLeasteOnePasskey() throws {
        BindPasskeyUITests.recoverExistingUser(existingUsername)
        PasskeyManagementUITests.clearAllPasskeys()
    }
    
    static public func deleteOnePasskey(_ passkeyId: String){
        let app = navigateToManagePasskeys()
        
        let title = app.otherElements.children(matching: .staticText)[PasskeyManagementUITests.deletePasskeyButton]
        XCTAssertTrue(title.exists)
        
        let passkeyIdField = app.textFields["Passkey ID"]
        XCTAssertTrue(passkeyIdField.exists)
        
        let button = app.buttons[PasskeyManagementUITests.deletePasskeyButton]
        XCTAssertTrue(button.exists)
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: PasskeyManagementUITests.deletePasskeyButton)
        XCTAssertTrue(responseLabel.exists)
        
        // doubleTap allows overriding any previous text field entry
        passkeyIdField.waitUntilExists().doubleTap()
        waitUntilElementHasFocus(element: passkeyIdField).typeText(passkeyId)
        // tapping title to bring focus after keyboard typing so test can find the button
        title.tap()
        button.tap()
        
        responseExpecting("Deleted Passkey Id: \(passkeyId)", from: responseLabel, { _ in })
    }
    
    static public func clearAllPasskeys() {
        let app = navigateToManagePasskeys()
        
        let button = app.buttons[PasskeyManagementUITests.viewPasskeysButton]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let responseLabel = getResponseLabel(from: app, buttonTitle: PasskeyManagementUITests.viewPasskeysButton)
        XCTAssertTrue(responseLabel.exists)
        
        getResponseValue(from: responseLabel) { response in
            if response.contains(noPasskeyText) {
                return
            }
            
            let passkeyIds = getPasskeyIds(from: response)
            
            for passkeyId in passkeyIds {
                PasskeyManagementUITests.deleteOnePasskey(passkeyId)
            }
        }
    }
}
