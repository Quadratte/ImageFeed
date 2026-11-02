import UIKit

final class YPButton: UIButton {

    let title: String
    let id: String?

    init(_ title: String, id: String? = nil) {
        self.title = title
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
        backgroundColor = .ypWhite
        setTitle(title, for: .normal)
        setTitleColor(.ypBlack, for: .normal)
        layer.cornerRadius = 16
        layer.masksToBounds = true
        accessibilityIdentifier = id
        accessibilityLabel = title
        isAccessibilityElement = true
    }
}
