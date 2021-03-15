import AuthenticationServices
import XCTest
@testable import BISDK

class AuthViewTests: XCTestCase {
    private var authView: AuthView!
    
    override func setUp() {
        super.setUp()
        let session = ASWebAuthenticationSessionMock(mockClosure: {})
        authView = AuthView(session: session, signUpAction: { })
    }
    
    override func tearDown() {
        authView = nil
        super.tearDown()
    }
    
    func test_authView_signInButton_title() {
        XCTAssertEqual(authView.signInButton.title, "Log in with Beyond Identity")
    }
    
    func test_authView_signUpButton_title() {
        XCTAssertEqual(authView.signUpButton.title, "New to Beyond Identity? Go passwordless today")
    }
    
    func test_authView_signUpButton_tapped_callsSignUpAction() {
        var capture: Bool = false
        let session = ASWebAuthenticationSessionMock(mockClosure: {})
        let authView = AuthView(session: session, signUpAction: { capture = true })
        
        XCTAssertFalse(capture, "Precondition")
        authView.signUpButton.simulateEvent(.touchUpInside)
        XCTAssertTrue(capture)
    }
    
    func test_authView_signInButton_tapped_startSession() {
        var capture: Bool = false
        let session = ASWebAuthenticationSessionMock(mockClosure: { capture = true })
        let authView = AuthView(session: session, signUpAction: {})
        
        XCTAssertFalse(capture, "Precondition")
        authView.signInButton.simulateEvent(.touchUpInside)
        XCTAssertTrue(capture)
    }
    
    func test_authView_interfacesPresentationContext() throws {
        XCTAssertNotNil(authView.presentationAnchor)
    }
    
}

extension UIControl {
    fileprivate func simulateEvent(_ event: UIControl.Event) {
        for target in allTargets {
            let target = target as NSObjectProtocol
            for actionName in actions(forTarget: target, forControlEvent: event) ?? [] {
                let selector = Selector(actionName)
                target.perform(selector)
            }
        }
    }
}

fileprivate class ASWebAuthenticationSessionMock: ASWebAuthenticationSession {
    private let mockClosure: () -> Void
    
    init(mockClosure: @escaping () -> Void) {
        self.mockClosure = mockClosure
        let url = URL(string: "http://")!
        super.init(
            url: url,
            callbackURLScheme: nil,
            completionHandler: { _,_  in })
    }
    
    override func start() -> Bool {
        mockClosure()
        return true
    }
}
