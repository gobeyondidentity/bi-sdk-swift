import Foundation

enum LocalizedString: String, CaseIterable {
    case signInButtonTitle
    case signUpButtonTitle

    static func value(for key: Self) -> String {
        NSLocalizedString(key.rawValue, tableName: nil, bundle: .module, value: "not found", comment: "")
    }
}
