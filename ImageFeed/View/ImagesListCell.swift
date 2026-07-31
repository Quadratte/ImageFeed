import UIKit

final class ImagesListCell: UITableViewCell {

    static let id: String = "ImagesListCell"

    private let cardImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = ._0
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        return image
    }()

    private let favoriteButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(.active, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.contentVerticalAlignment = .center
        btn.contentHorizontalAlignment = .center
        return btn
    }()

    private let cardlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "27 августа 2022"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()

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

    func configure(image: UIImage, date: String, isLiked: Bool) {
        cardImage.image = image
        cardlabel.text = date

        let likeImage = isLiked ? UIImage(named: "inactive") : UIImage(named: "active")
        favoriteButton.setImage(likeImage, for: .normal)
    }

    private func setupUI() {
        contentView.backgroundColor = .ypBlack
        contentView.addSubview(cardImage)
        cardImage.addSubview(favoriteButton)
        cardImage.addSubview(cardlabel)
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

            cardlabel.leadingAnchor.constraint(equalTo: cardImage.leadingAnchor, constant: 8),
            cardlabel.bottomAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: -8),
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

    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradient = cardImage.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradient.frame = cardImage.bounds
        }
    }
}
