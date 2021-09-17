import Foundation

enum ClientType: String {
    case confidential
    case `public`
}

enum Demo: String {
    case authenticator
    case embedded
    case embeddedUI
}

extension UserDefaults {
    enum Key: String, RawRepresentable {
        case auth
        case demo
    }
    
    static func set(_ value: ClientType) {
        UserDefaults.standard.set(value.rawValue, forKey: Key.auth.rawValue)
    }
    
    static func set(_ value: Demo) {
        UserDefaults.standard.set(value.rawValue, forKey: Key.demo.rawValue)
    }
    
    static func getClientType() -> ClientType {
        let rawValue = UserDefaults.standard.string(forKey: Key.auth.rawValue) ?? ""
        return ClientType(rawValue: rawValue) ?? .confidential
    }
    
    static func getDemo() -> Demo? {
        guard let rawValue = UserDefaults.standard.string(forKey: Key.demo.rawValue) else { return nil }
        return Demo(rawValue: rawValue) ?? nil
    }
}
