import CoreSDK
import Foundation


/// Proof Key for Code Exchange (PKCE, pronounced "pixy") used by public clients to [mitigate authorization code interception attack.](https://datatracker.ietf.org/doc/html/rfc7636)
public struct PKCE: Equatable {
    
    /// a one-time high-entropy cryptographic random `String` used to correlate the authorization request to the token request
    public let codeVerifier: String
    
    /// contains the `challenge` derived from the `codeVerifier` and `method` used to derive this value
    public let codeChallenge: CodeChallenge

    init(_ pkce: CoreSDK.PKCE) {
        codeVerifier = pkce.codeVerifier.value
        codeChallenge = CodeChallenge(pkce.codeChallenge)
    }
    
    /// initalize `PKCE` with a `codeVerifier` and `codeChallenge`
    public init(codeVerifier: String, codeChallenge: CodeChallenge){
        self.codeVerifier = codeVerifier
        self.codeChallenge = codeChallenge
    }
    
    /// Proof Key for Code Exchange (PKCE, pronounced "pixy") CodeChallenge used by public clients to [mitigate authorization code interception attack.](https://datatracker.ietf.org/doc/html/rfc7636)
    public struct CodeChallenge: Equatable {
        
        /// derived from the `codeVerifier`. Send to the authorization request, to be verified against later.
        public let challenge: String
        
        /// a method that was used to derive the `challenge`
        public let method: String

        init(_ codeChallenge: CoreSDK.PKCE.CodeChallenge) {
            challenge = codeChallenge.challenge
            method = codeChallenge.method
        }
        
        /// initalize `CodeChallenge` with a `challenge` and `method`
        public init(challenge: String, method: String){
            self.challenge = challenge
            self.method = method
        }
    }
}

extension CoreSDK.PKCE.CodeChallenge {
    init(_ codeChallenge: PKCE.CodeChallenge) {
        self.init(challenge: codeChallenge.challenge, method: codeChallenge.method)
    }
}
