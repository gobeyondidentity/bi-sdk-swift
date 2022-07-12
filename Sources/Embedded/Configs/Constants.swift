import Foundation

// THIS FILE IS GENERATED. DO NOT EDIT.

struct Configuration {
    #if os(iOS)
    static let catalogFolderName = "com.beyondidentity.sdk.BISDK.ios"
    #elseif os(macOS)
    static let catalogFolderName = "com.beyondidentity.sdk.BISDK.macos"
    #endif

    static let deviceGateway = "https://device-gateway.byndid.com"
    static let sdkVersion = "1.0.2"
}
