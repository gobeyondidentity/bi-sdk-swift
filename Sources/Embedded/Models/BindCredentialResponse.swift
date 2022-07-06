import CoreSDK
import Foundation

/// A response returned after successfully binding a credential to a device.
public struct BindCredentialResponse: Equatable {
    /// The `Credential` bound to the device.
    public let credential: Credential
    /// A URI that can be redirected to once a credential is bound. This could be a URI that automatically logs the user in with the newly bound credential, or a success page indicating that a credential has been bound.
    public let postBindingRedirectURI: URL?
    
    public init(
        credential: Credential,
        postBindingRedirectURI: URL?
    ){
        self.credential = credential
        self.postBindingRedirectURI = postBindingRedirectURI
    }
    
    init(_ response: CoreSDK.BindCredentialResponse) {
        self.credential = Credential(response.credential)
        self.postBindingRedirectURI = response.postBindingRedirectURI
    }
}
