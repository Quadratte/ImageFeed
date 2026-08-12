import UIKit

final class ProfileViewController: UIViewController {

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

    private let exitButton = YPButton(.exit)
    private let userImage = YPImageView()
    private let usernameLabel = YPLabel(.primary, .ypWhite, "Екатерина Новикова")
    private let userURL = YPLabel(.secondary, .ypGray, "@ekaterina_nov")
    private let userInfo = YPLabel(.secondary, .ypWhite, "Hello world!")

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupUI()
        setupConstraints()
    }

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Configure
    private func configure() {
        userImage.image = .photo
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .ypBlack
        view.addSubview(mainStack)

        mainStack.addArrangedSubview(headerStack)
        mainStack.addArrangedSubview(usernameLabel)
        mainStack.addArrangedSubview(userURL)
        mainStack.addArrangedSubview(userInfo)

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
}
