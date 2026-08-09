import UIKit

final class ImagesListCell: UITableViewCell {

    static let id: String = "ImagesListCell"

    // MARK: - UI Components
    private let favoriteButton = YPButton(.active)
    private let cardImage = YPImageView()
    private let cardLabel = YPLabel(.secondary, .ypWhite)

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupGradient()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradient = cardImage.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradient.frame = cardImage.bounds
        }
    }

    // MARK: - Configure
    func configure(image: UIImage, date: String, isLiked: Bool) {
        cardImage.image = image
        cardLabel.text = date

        let likeImage = isLiked ? UIImage(named: "inactive") : UIImage(named: "active")
        favoriteButton.setImage(likeImage, for: .normal)
    }

    // MARK: - Setup
    private func setupUI() {
        contentView.backgroundColor = .ypBlack
        contentView.addSubview(cardImage)
        cardImage.addSubview(favoriteButton)
        cardImage.addSubview(cardLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cardImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            favoriteButton.topAnchor.constraint(equalTo: cardImage.topAnchor, constant: 0),
            favoriteButton.trailingAnchor.constraint(equalTo: cardImage.trailingAnchor, constant: 0),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),

            cardLabel.leadingAnchor.constraint(equalTo: cardImage.leadingAnchor, constant: 8),
            cardLabel.bottomAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: -8),
        ])
    }

    private func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = cardImage.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.6).cgColor]
        gradient.locations = [0.4, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.7)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        cardImage.layer.insertSublayer(gradient, at: 0)
    }
}
