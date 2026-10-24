import UIKit

final class ImageButton: UIButton {

    var buttonImage: UIImage?
    let id: String?

    init(_ buttonImage: UIImage?, id: String? = nil) {
        self.buttonImage = buttonImage
        self.id = id
        super .init(frame: .zero)
        setupButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func setupButton() {
        translatesAutoresizingMaskIntoConstraints = false
        setImage(buttonImage, for: .normal)
        accessibilityIdentifier = id
        isAccessibilityElement = true
        imageView?.contentMode = .scaleAspectFit
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center
    }
}
