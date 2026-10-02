import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    // MARK: - Properties
    static let id = String(describing: ImagesListCell.self)
    weak var delegate: ImagesListCellDelegate?
    private let gradientView = GradientAnimationView()

    // MARK: - UI Components
    private let favoriteButton = ImageButton(.active)
    private let cardImage = YPImageView(.rounded)
    private let cardLabel = YPLabel(.secondary, .ypWhite)

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
        setupConstraints()
        setupGradient()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        gradientView.removeAnimation()
        cardImage.kf.cancelDownloadTask()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradient = cardImage.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradient.frame = cardImage.bounds
        }
    }

    // MARK: - Configure
    func configure(imageURL: URL?, date: String, isLiked: Bool) {
        cardImage.kf.indicatorType = .activity
        cardImage.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "stub"),
            options: [.transition(.fade(0.3))]
        )
        self.gradientView.removeAnimation()
        cardLabel.text = date

        setIsLiked(isLiked)
    }

    // MARK: - HitTest
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let buttonPoint = convert(point, to: favoriteButton)
        if favoriteButton.point(inside: buttonPoint, with: event) {
            return favoriteButton
        }
        return super.hitTest(point, with: event)
    }

    // MARK: - Setup
    private func setupUI() {
        contentView.backgroundColor = .ypBlack
        contentView.addSubview(cardImage)
        cardImage.addSubview(gradientView)
        cardImage.addSubview(favoriteButton)
        cardImage.addSubview(cardLabel)
    }

    private func setupActions() {
        favoriteButton.addAction(UIAction { [weak self] _ in
            self?.likeButtonTapped()
        }, for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: cardImage.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: cardImage.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cardImage.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: cardImage.bottomAnchor),

            cardImage.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            cardImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cardImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cardImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),

            favoriteButton.topAnchor.constraint(equalTo: cardImage.topAnchor, constant: 0),
            favoriteButton.trailingAnchor.constraint(equalTo: cardImage.trailingAnchor, constant: 0),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),

            cardLabel.leadingAnchor.constraint(equalTo: cardImage.leadingAnchor, constant: 8),
            cardLabel.bottomAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: -8)
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

    private func likeButtonTapped() {
        delegate?.imageListCellDidTapLike(self)
    }

    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "active") : UIImage(named: "inactive")
        favoriteButton.setImage(likeImage, for: .normal)
    }
}
