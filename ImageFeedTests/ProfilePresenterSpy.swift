import Foundation
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled = false
    var didTapLogoutCalled = false
    var logoutCalled = false

    func viewDidLoad() { viewDidLoadCalled = true }
    func didTapLogout() { didTapLogoutCalled = true }
    func logout() { logoutCalled = true }
}
