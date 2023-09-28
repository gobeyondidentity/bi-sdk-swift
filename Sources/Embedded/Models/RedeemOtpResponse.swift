import Foundation

/// A response returned after attempting to redeem an OTP
public enum RedeemOtpResponse: Equatable, Hashable {
    /// A response returned after successfully authenticating.
    case success(AuthenticateResponse)
    /// A response returned on failure to authenticate with the provided OTP code.
    /// Use `OtpChallengeResponse.url` to initiate a retry on either `redeemOtp` or `authenticateOtp`
    case failedOtp(OtpChallengeResponse)
}
