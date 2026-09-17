import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() { }

    private let tokenKey = "bearerToken"
    private let isFirstLaunchKey = "isFirstLaunch"

    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: "tokenKey")
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: "tokenKey")
            } else {
                KeychainWrapper.standard.removeObject(forKey: "tokenKey")
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
