import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() { }

    private let isFirstLaunchKey = "isFirstLaunch"
    private let tokenKeyName = "tokenKey"

    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKeyName)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: tokenKeyName)
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKeyName)
            }
        }
    }

    func clearOnFirstLaunch() {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: isFirstLaunchKey)
        if isFirstLaunch {
            token = nil
            UserDefaults.standard.set(true, forKey: isFirstLaunchKey)
        }
    }
}
