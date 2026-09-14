import UIKit

final class SplashViewController: UIViewController {

    // MARK: - Properties
    private let storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthStatus()
    }
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .ypBlack
    }

    // MARK: - Private methods

    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self else { return }

            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure:
                self.showAuthViewController()
            }
        }
    }

    private func checkAuthStatus() {
        if storage.token != nil {
            switchToTabBarController()
        } else {
            showAuthViewController()
        }
    }

    // MARK: - Show
    private func showAuthViewController() {
        let authVC = AuthViewController()
        authVC.delegate = self
        navigationController?.pushViewController(authVC, animated: true)
    }

    private func switchToTabBarController() {
        let window = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }

        let tabBarController = TabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        navigationController?.popViewController(animated: true)
        guard let token = storage.token else { return }
        fetchProfile(token)
    }
}
