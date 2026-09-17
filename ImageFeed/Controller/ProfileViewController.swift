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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            headerStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor),

            userImage.heightAnchor.constraint(equalToConstant: 70),
            userImage.widthAnchor.constraint(equalToConstant: 70),
        ])
    }

    //MARK: - Observer
    private func addObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            self.configureProfile(profile: profileService.profile)
        }
        self.configureProfile(profile: profileService.profile)
    }
}
