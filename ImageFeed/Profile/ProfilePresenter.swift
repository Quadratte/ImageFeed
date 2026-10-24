import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLogout()
    func logout()
}

final class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewControllerProtocol?
    private let profileService: ProfileService
    private let profileImageService: ProfileImageService
    private let logoutService: ProfileLogoutService
    private var profileImageServiceObserver: NSObjectProtocol?

    init(
        profileService: ProfileService = .shared,
        profileImageService: ProfileImageService = .shared,
        logoutService: ProfileLogoutService = .shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.logoutService = logoutService
    }

    func viewDidLoad() {
        addObserver()
        view?.updateProfile(profile: profileService.profile)
        let url = profileImageService.avatarURL.flatMap { URL(string: $0) }
        view?.updateAvatar(url: url)
    }

    func didTapLogout() {
        view?.showLogoutAlert()
    }

    func logout() {
        logoutService.logout()
        view?.switchToAuth()
    }

    private func addObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            if let avatarURL = self.profileImageService.avatarURL {
                self.view?.updateAvatar(url: URL(string: avatarURL))
            }
        }
    }
}
