import Foundation

extension UserDefaults {
    enum DefaultsKey: String {
        case appInstanceId
    }

    static func setString(_ value: String, forKey key: DefaultsKey) -> String {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        return value
    }

    static func get(forKey key: DefaultsKey) -> String? {
        UserDefaults.standard.string(forKey: key.rawValue)
    }
}
