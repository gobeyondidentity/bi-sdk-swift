import Foundation

enum LocalizedString: String, CaseIterable {
    case SignInButtonTitle
    case SignUpButtonTitle
    
    static func value(for key: Self) -> String {
        NSLocalizedString(key.rawValue, tableName: nil, bundle: .module, value: "not found", comment: "")
    }
}
