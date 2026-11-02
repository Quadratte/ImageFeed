import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfile(profile: Profile?)
    func updateAvatar(url: URL?)
    func showLogoutAlert()
    func switchToAuth()
    func removeGradients()
}

final class ProfileViewController: UIViewController {

    // MARK: - Properties
    var presenter: ProfilePresenterProtocol?

    // MARK: - UI Components
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        return stack
    }()

    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()

    private let exitButton = ImageButton(.exit)
    private let userImage = YPImageView(.photo)
    private let usernameLabel = YPLabel(.primary, .ypWhite, "Екатерина Новикова")
    private let userURL = YPLabel(.secondary, .ypGray, "@ekaterina_nov")
    private let userInfo = YPLabel(.secondary, .ypWhite, "Hello world!")

    // MARK: - Animation
    private let avatarGradient = GradientAnimationView()
    private let nameGradient = GradientAnimationView()
    private let loginGradient = GradientAnimationView()
    private let bioGradient = GradientAnimationView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupConstraints()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Configure
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
        exitButton.accessibilityIdentifier = "logout button"
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .ypBlack
        view.addSubview(mainStack)

        let subViews = [headerStack, usernameLabel, userURL, userInfo]
        subViews.forEach { mainStack.addArrangedSubview($0) }

        headerStack.addArrangedSubview(userImage)
        headerStack.addArrangedSubview(exitButton)

        [avatarGradient, nameGradient, loginGradient, bioGradient].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainStack.addSubview($0)
        }
    }

    private func setupActions() {
        exitButton.addAction(UIAction { [weak self] _ in
            self?.presenter?.didTapLogout()
        }, for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarGradient.topAnchor.constraint(equalTo: userImage.topAnchor),
            avatarGradient.leadingAnchor.constraint(equalTo: userImage.leadingAnchor),
            avatarGradient.trailingAnchor.constraint(equalTo: userImage.trailingAnchor),
            avatarGradient.bottomAnchor.constraint(equalTo: userImage.bottomAnchor),

            nameGradient.topAnchor.constraint(equalTo: usernameLabel.topAnchor),
            nameGradient.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            nameGradient.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            nameGradient.bottomAnchor.constraint(equalTo: usernameLabel.bottomAnchor),

            loginGradient.topAnchor.constraint(equalTo: userURL.topAnchor),
            loginGradient.leadingAnchor.constraint(equalTo: userURL.leadingAnchor),
            loginGradient.trailingAnchor.constraint(equalTo: userURL.trailingAnchor),
            loginGradient.bottomAnchor.constraint(equalTo: userURL.bottomAnchor),

            bioGradient.topAnchor.constraint(equalTo: userInfo.topAnchor),
            bioGradient.leadingAnchor.constraint(equalTo: userInfo.leadingAnchor),
            bioGradient.trailingAnchor.constraint(equalTo: userInfo.trailingAnchor),
            bioGradient.bottomAnchor.constraint(equalTo: userInfo.bottomAnchor),

            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            headerStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor),

            userImage.heightAnchor.constraint(equalToConstant: 70),
            userImage.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}

// MARK: - ProfileViewControllerProtocol
extension ProfileViewController: ProfileViewControllerProtocol {

    func updateProfile(profile: Profile?) {
        guard let profile else { return }

        usernameLabel.text = profile.name
        userURL.text = profile.username
        userInfo.text = profile.bio ?? "Нет описания"
    }

    func updateAvatar(url: URL?) {
        avatarGradient.removeAnimation()
        nameGradient.removeAnimation()
        loginGradient.removeAnimation()
        bioGradient.removeAnimation()

        guard let url else { return }

        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        userImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder.jpeg"),
            options: [.processor(processor), .cacheOriginalImage, .transition(.fade(1))]
        )
        userImage.layer.cornerRadius = userImage.bounds.width / 2
        userImage.layer.masksToBounds = true
    }

    func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.presenter?.logout()
        })
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))

        present(alert, animated: true)
    }

    func switchToAuth() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }

        window.rootViewController = NavController(rootViewController: SplashViewController())
        window.makeKeyAndVisible()
    }

    func removeGradients() {
        avatarGradient.removeAnimation()
        nameGradient.removeAnimation()
        loginGradient.removeAnimation()
        bioGradient.removeAnimation()
    }
}
