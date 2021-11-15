import AuthenticationServices
import XCTest
@testable import BeyondIdentityAuthenticator
@testable import SharedDesign

class AuthViewTests: XCTestCase {
    private var authView: AuthView!

    override func setUp() {
        super.setUp()
        authView = AuthView(
            url: URL(string: "http://")!,
            callbackURLScheme: "scheme",
            completionHandler: { _, _  in },
            signUpAction: { }
        )
    }

    override func tearDown() {
        authView = nil
        super.tearDown()
    }

    func test_authView_signInButton_title() {
        XCTAssertEqual(authView.signInButton.titleLabel.text, "Log in with Beyond Identity")
    }

    func test_authView_signUpButton_title() {
        XCTAssertEqual(authView.signUpButton.title, "New to Beyond Identity? Go passwordless today")
    }

    func test_authView_signUpButton_tapped_callsSignUpAction() {
        var capture: Bool = false
        let authView = AuthView(
            url: URL(string: "http://")!,
            callbackURLScheme: "scheme",
            completionHandler: { _, _  in },
            signUpAction: { capture = true })

        XCTAssertFalse(capture, "Precondition")
        authView.signUpButton.simulateEvent(.touchUpInside)
        XCTAssertTrue(capture)
    }

    func test_authView_signInButton_tapped_callsCreateSessionAndStartSession() {
        let authView = AuthViewMock(
            url: URL(string: "http://")!,
            callbackURLScheme: "scheme",
            completionHandler: { _, _  in },
            signUpAction: { }
        )

        XCTAssertFalse(authView.createSessionCalled, "Precondition")
        XCTAssertFalse(authView.startSessionCalled, "Precondition")

        authView.signInButton.simulateEvent(.touchUpInside)

        XCTAssertTrue(authView.startSessionCalled)
        XCTAssertTrue(authView.createSessionCalled)
    }

    func test_startSession() {
        var capture: Bool = false
        let session = ASWebAuthenticationSessionMock(mockClosure: { capture = true })

        XCTAssertFalse(capture, "Precondition")
        authView.startSession(session)
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

private class ASWebAuthenticationSessionMock: ASWebAuthenticationSession {
    private let mockClosure: () -> Void

    init(mockClosure: @escaping () -> Void) {
        self.mockClosure = mockClosure
        let url = URL(string: "http://")!
        super.init(
            url: url,
            callbackURLScheme: nil,
            completionHandler: { _, _  in })
    }

    override func start() -> Bool {
        mockClosure()
        return true
    }
}

private class AuthViewMock: AuthView {
    var createSessionCalled = false
    var startSessionCalled = false

    override func createSession(
        url: URL,
        callbackURLScheme: String?,
        completionHandler: @escaping ASWebAuthenticationSession.CompletionHandler,
        prefersEphemeralWebBrowserSession: Bool = false) -> ASWebAuthenticationSession {
        createSessionCalled = true
        return ASWebAuthenticationSessionMock(mockClosure: {})
    }
    override func startSession(_ session: ASWebAuthenticationSession) {
        startSessionCalled = true
    }
}
