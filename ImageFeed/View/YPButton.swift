import UIKit

final class YPButton: UIButton {

    init() {
        super .init(frame: .zero)
        setupButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
       nil
    }

    private func setupButton() {
      translatesAutoresizingMaskIntoConstraints = false
      setImage(.active, for: .normal)
      imageView?.contentMode = .scaleAspectFit
      contentVerticalAlignment = .center
      contentHorizontalAlignment = .center
    }
}
