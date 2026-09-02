import UIKit

final class YPButton: UIButton {

    let title: String

    init(_ title: String) {
        self.title = title
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
    }
}
