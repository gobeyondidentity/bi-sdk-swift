import CoreSDK
import Foundation

/// A response returned if the SDK requires an OTP.
public struct OtpChallengeResponse: Equatable, Hashable {
    /// A URL containing the state of the current authentication transaction.
    /// This should be used in the next `redeemOtp` or `authenticateOtp` function.
    public let url: URL
    
    public init(url: URL){
        self.url = url
    }
    
    init(_ response: CoreSDK.BiContinueResponse) {
        self.url = response.url
    }
}
