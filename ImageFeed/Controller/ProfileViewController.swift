import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {

    // MARK: - Properties
    let profileService = ProfileService.shared
    let avatarURL = ProfileImageService.shared.avatarURL
    private var profileImageServiceObserver: NSObjectProtocol?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupConstraints()
        addObserver()
    }

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Configure
    private func configureProfile(profile: Profile?) {

        guard
            let profile,
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageUrl = URL(string: profileImageURL)
                else { return }

        avatarGradient.removeAnimation()
        nameGradient.removeAnimation()
        loginGradient.removeAnimation()
        bioGradient.removeAnimation()

        let processor = RoundCornerImageProcessor(cornerRadius: 35)

        userImage.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "placeholder.jpeg"),
            options: [.processor(processor),
                      .cacheOriginalImage,
                      .transition(.fade(1))]
        )
        userImage.layer.cornerRadius = userImage.bounds.width / 2
        userImage.layer.masksToBounds = true
        usernameLabel.text = profile.name
        userURL.text = profile.username
        userInfo.text = profile.bio ?? "Нет описания"
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
            self?.showLogoutAlert()
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

    // MARK: - Observer
    private func addObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else { return }
                self.configureProfile(profile: profileService.profile)
            }
        self.configureProfile(profile: profileService.profile)
    }

    private func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Выход",
            message: "Вы уверены, что хотите выйти?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            ProfileLogoutService.shared.logout()
            self?.switchToAuthViewController()
        })
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))

        present(alert, animated: true)
    }

    private func switchToAuthViewController() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }

        window.rootViewController = NavController(rootViewController: SplashViewController())
        window.makeKeyAndVisible()
    }
}
