import Foundation
import Security
import CryptoKit

func appendPKCE(for url: URL) -> (url: URL, codeVerifier: PKCE.CodeVerifier)? {
    guard let pkce = PKCE() else { return nil }
    guard let urlWithPKCE = URL(
        string: url.absoluteString
        + "&code_challenge_method=\(pkce.method)"
        + "&code_challenge=\(pkce.codeChallenge.value)"
    ) else { return nil }
    
    return (urlWithPKCE, pkce.codeVerifier)
}

struct PKCE {
    enum CodeVerifierTag {}
    typealias CodeVerifier = Tagged<CodeVerifierTag, String>
    
    enum CodeChallengeTag {}
    typealias CodeChallenge = Tagged<CodeChallengeTag, String>
    
    let codeVerifier: CodeVerifier
    let codeChallenge: CodeChallenge
    let method = "S256"
    
    init?() {
        guard let verifier = generateCodeVerifier() else {
            return nil
        }
        guard let challenge = generateCodeChallenge(for: verifier) else {
            return nil
        }
        codeVerifier = CodeVerifier(verifier)
        codeChallenge = CodeChallenge(challenge)
    }
}

private func generateCryptographicallySecureRandomOctets(count: Int) -> [UInt8]? {
    var octets = [UInt8](repeating: 0, count: count)
    let status = SecRandomCopyBytes(kSecRandomDefault, octets.count, &octets)
    if status == errSecSuccess {
        return octets
    } else {
        return nil
    }
}

private func base64URLEncode<S>(octets: S) -> String where S : Sequence, UInt8 == S.Element {
    let data = Data(octets)
    return data
        .base64EncodedString() // Regular base64 encoder
        .replacingOccurrences(of: "=", with: "") // Remove any trailing '='s
        .replacingOccurrences(of: "+", with: "-") // 62nd char of encoding
        .replacingOccurrences(of: "/", with: "_") // 63rd char of encoding
        .trimmingCharacters(in: .whitespaces)
}

private func generateCodeVerifier() -> String? {
    guard let octets = generateCryptographicallySecureRandomOctets(count: 32) else {
        return nil
    }
    return base64URLEncode(octets: octets)
}

private func generateCodeChallenge(for verifier: String) -> String? {
    let challenge = verifier
        .data(using: .ascii)
        .map { SHA256.hash(data: $0) }
        .map { base64URLEncode(octets: $0) }
    
    if let challenge = challenge {
        return challenge
    } else {
        return nil
    }
}
