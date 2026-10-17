import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService(); private init() { }

    func logout() {
        cleanCookies()
        cleanToken()
        cleanProfile()
        cleanImages()
    }

    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(
                    ofTypes: record.dataTypes,
                    for: [record],
                    completionHandler: { }
                )
            }
        }
    }

    private func cleanToken() {
        OAuth2TokenStorage.shared.token = nil
    }

    private func cleanProfile() {
        ProfileService.shared.cleanProfile()
        ProfileImageService.shared.cleanAvatarURL()
    }

    private func cleanImages() {
        ImagesListService.shared.cleanPhotos()
    }
}
