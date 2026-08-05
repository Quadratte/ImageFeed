import UIKit

final class SingleImageViewController: UIViewController {

    private let imageView = YPImageView()
    private let backButton = YPButton()
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupUI()
        setupActions()
        setupConstraints()
    }

    private func configure() {
        imageView.image = image
        backButton.setImage(.backward, for: .normal)
    }

    private func setupUI() {
        view.backgroundColor = .ypBlack
        view.addSubview(imageView)
        view.addSubview(backButton)
    }

    private func setupActions() {
        backButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 11),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
}
