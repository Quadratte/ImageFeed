import UIKit

final class SplashViewController: UIViewController {

    private let storage = OAuth2TokenStorage()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthStatus()
    }

    private func setupUI() {
        view.backgroundColor = .ypBlack
    }

    private func checkAuthStatus() {
        if storage.token != nil {
            switchToTabBarController()
        } else {
            showAuthViewController()
        }
    }

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
        switchToTabBarController()
    }
}
