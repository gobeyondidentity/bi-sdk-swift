import XCTest

final class SupportUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testDeveloperDocsNavigatesAndExists() throws {
        let app = navigateToSDK()
        
        let button = app.scrollViews.staticTexts["View Developer Docs"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        
        let webView = app.webViews.element
        
        if webView.waitForExistence(timeout: 10) {
            sleep(2)
            
            let allTextOnWebPage = webView.staticTexts.allElementsBoundByIndex.compactMap({ $0.value })
            
            let pageNotFound = webView.staticTexts["Page Not Found"]
            XCTAssertTrue(!pageNotFound.exists, "Found \"Page Not Found\" on web page.")
            
            let developerDocs = webView.staticTexts["Developer Documentation"]
            XCTAssertTrue(developerDocs.exists, "Could not find \"Developer Documentation\" on web page.\n Found: \(allTextOnWebPage)")
        } else {
            XCTFail("webView is missing")
        }
    }
    
    func testVisitSupportNavigatesToSlack() throws {
        let app = navigateToSDK()
        
        let button = app.scrollViews.staticTexts["Visit Support"]
        XCTAssertTrue(button.exists)
        
        button.tap()
        
        let webView = app.webViews.element
        
        if webView.waitForExistence(timeout: 10) {
            sleep(2)
            
            let allTextOnWebPage = webView.staticTexts.allElementsBoundByIndex.compactMap({ $0.value })
            
            let pageNotFound = webView.staticTexts["Page Not Found"]
            XCTAssertTrue(!pageNotFound.exists, "Found \"Page Not Found\" on web page.")
            
            let developerDocs = webView.staticTexts["Open Slack"]
            XCTAssertTrue(developerDocs.exists, "Could not find \"Open Slack\" on web page.\n Found: \(allTextOnWebPage)")
        } else {
            XCTFail("webView is missing")
        }
    }
    
}
