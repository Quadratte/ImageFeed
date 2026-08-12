import UIKit

final class YPButton: UIButton {

    var buttonImage: UIImage?

    init(_ buttonImage: UIImage) {
        self.buttonImage = buttonImage
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
      imageView?.contentMode = .scaleAspectFit
      contentVerticalAlignment = .center
      contentHorizontalAlignment = .center
    }
}
