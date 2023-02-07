import CoreSDK
import Foundation

/// A response returned after successfully binding a passkey to a device.
public struct BindPasskeyResponse: Equatable, Hashable {
    /// The `Passkey` bound to the device.
    public let passkey: Passkey
    /// A URI that can be redirected to once a passkey is bound. This could be a URI that automatically logs the user in with the newly bound passkey, or a success page indicating that a passkey has been bound.
    public let postBindingRedirectUri: URL?
    
    public init(
        passkey: Passkey,
        postBindingRedirectUri: URL?
    ){
        self.passkey = passkey
        self.postBindingRedirectUri = postBindingRedirectUri
    }
    
    init(_ response: CoreSDK.BindCredentialResponse) {
        self.passkey = Passkey(response.credential)
        self.postBindingRedirectUri = response.postBindingRedirectURI
    }
}
