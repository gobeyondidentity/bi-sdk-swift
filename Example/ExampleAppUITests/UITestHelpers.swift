import XCTest

public let emptyResponseLabel = "RESPONSE DATA"
public let noPasskeyText = "No Passkey found, bind a Passkey first"
public let existingUsername = "a"

/// Check that an expected response matches
public func responseExpecting(
    _ result: String,
    from responseLabel: XCUIElement,
    _ callback: ((String) -> Void),
    file: StaticString = #filePath,
    line: UInt = #line
) {
    if responseLabel.textViews[result].waitForExistence(timeout: 10),
       let string = responseLabel.value as? String {
        callback(string)
    } else {
        XCTFail("Response Label Output:\n Expected: \(result)\n Got: \(String(describing: responseLabel.value))", file: file, line: line)
    }
}

/// Get the response value and make own assertion on that.
/// Default to timeout 1. Tiime will wait exactly amount specificed, won't short circuit like `responseExpecting`
public func getResponseValue(
    _ wait: Double = 1,
    from responseLabel: XCUIElement,
    _ callback: ((String) -> Void),
    file: StaticString = #filePath,
    line: UInt = #line
){
    // just wait to get any text result
    if !responseLabel.textViews[""].waitForExistence(timeout: wait) {
        let response = responseLabel.value as! String
        XCTAssertNotEqual(response, emptyResponseLabel, "No result given, wait longer.\n Returned: \(response)", file: file, line: line)
        callback(response)
    } else {
        XCTFail("responseLabel has no value.\n Got: \(String(describing: responseLabel.value))", file: file, line: line)
    }
}

/// appends "Response" to the button title to find responseLabel.
/// See ResponseLabelView used in ButtonView and InputView
public func getResponseLabel(from app: XCUIApplication, buttonTitle: String) -> XCUIElement {
    return app.otherElements.textViews["\(buttonTitle) Response"]
}

/// Current Date String without whitespace or :
public func getCurrentDate() -> String {
    return "\(Date.now)"
        .components(separatedBy: .whitespacesAndNewlines)
        .joined()
        .replacingOccurrences(of:":", with: "")
}

public func getPasskeyIds(from response: String) -> [String] {
    let components = response.components(separatedBy: "\n")
    // get all ids
    let ids = components.filter { item in
        item.contains("id:")
    }
    // get every 4th id to filter out tenant, realm, identity ids
    let passkeyIdsEnumerated = ids.enumerated().filter { (index, id) in
        index % 4 == 0
    }
    // pull out if from id: 1234
    let passkeyIds = passkeyIdsEnumerated.map { (index, element) in
        let idParts = element.components(separatedBy: ": ")
        return idParts[1]
    }
    return passkeyIds
}

public func navigateToSDK() -> XCUIApplication {
    let app = XCUIApplication()
    app.launch()
    
    let screen = app.scrollViews.staticTexts["View Embedded SDK"]
    XCTAssertTrue(screen.exists)
    screen.tap()
    
    return app
}

public func navigateToManagePasskeys() -> XCUIApplication {
    let app = navigateToSDK()
    
    let screen = app.scrollViews.staticTexts["Manage Passkeys"]
    XCTAssertTrue(screen.exists)
    screen.tap()
    
    return app
}

public func navigateToAuthenticate() -> XCUIApplication {
    let app = navigateToSDK()
    
    let screen = app.scrollViews.staticTexts["Authenticate"]
    XCTAssertTrue(screen.exists)
    screen.tap()
    
    return app
}

public func navigateToURLValidation() -> XCUIApplication {
    let app = navigateToSDK()
    
    let screen = app.scrollViews.staticTexts["URL Validation"]
    XCTAssertTrue(screen.exists)
    screen.tap()
    
    return app
}

public extension XCUIElement {
    var hasFocus: Bool { value(forKey: "hasKeyboardFocus") as? Bool ?? false }
}

public extension XCTestCase {
    static func waitUntilElementHasFocus(element: XCUIElement, timeout: TimeInterval = 600, file: StaticString = #file, line: UInt = #line) -> XCUIElement {
        let testCase = XCTestCase()
        let expectation = testCase.expectation(description: "waiting for element \(element) to have focus")
        
        let timer = Timer(timeInterval: 1, repeats: true) { timer in
            guard element.hasFocus else { return }
            
            expectation.fulfill()
            timer.invalidate()
        }
        
        RunLoop.current.add(timer, forMode: .common)
        
        testCase.wait(for: [expectation], timeout: timeout)
        
        return element
    }
    
    func waitUntilElementHasFocus(element: XCUIElement, timeout: TimeInterval = 600, file: StaticString = #file, line: UInt = #line) -> XCUIElement {
        return XCTestCase.waitUntilElementHasFocus(element: element, timeout: timeout, file: file, line: line)
    }
}

extension XCUIElement {
    func waitUntilExists(timeout: TimeInterval = 600, file: StaticString = #file, line: UInt = #line) -> XCUIElement {
        let elementExists = waitForExistence(timeout: timeout)
        if elementExists {
            return self
        } else {
            XCTFail("Could not find \(self) before timeout", file: file, line: line)
        }
        
        return self
    }
}
