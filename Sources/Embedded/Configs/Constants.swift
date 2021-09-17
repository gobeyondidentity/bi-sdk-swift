import Foundation

// THIS FILE IS GENERATED. DO NOT EDIT.

struct Configuration {
    #if os(iOS)
    static let catalogFolderName = "com.beyondidentity.sdk.BISDK.ios"
    #elseif os(macOS)
    static let catalogFolderName = "com.beyondidentity.sdk.BISDK.macos"
    #endif

    static let deviceGateway = "https://device-gateway.byndid.com"
    static let migratedAddress = "https://migrated.grpc.byndid.com:443"
}

enum Endpoint: String, CaseIterable {
    case authorizeEndpoint = "https://auth.byndid.com/v2/authorize"
    case tokenEndpoint = "https://auth.byndid.com/v2/token"

    static func url(for key: Endpoint) -> URL? {
        URL(string: key.rawValue)
    }
}
