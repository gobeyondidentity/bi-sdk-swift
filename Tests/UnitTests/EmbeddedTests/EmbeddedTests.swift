@testable import BeyondIdentityEmbedded
import XCTest

class EmbeddedTests: XCTestCase {
    
    func test_config_toggles_clientID_whenCallingInitialize(){
        XCTAssertNil(CoreEmbedded.config?.clientID, "precondition")
        
        Embedded.initialize(
            biometricAskPrompt: "",
            clientID: "1",
            redirectURI: "")
        
        XCTAssertEqual(CoreEmbedded.config?.clientID, "1", "first init")
        
        Embedded.initialize(
            biometricAskPrompt: "",
            clientID: "2",
            redirectURI: "")
        
        XCTAssertEqual(CoreEmbedded.config?.clientID, "2")
    }
    
}
