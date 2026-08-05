import UIKit

final class YPImageView: UIImageView {

    init() {
        super .init(frame: .zero)
        setupImage()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupImage() {
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        layer.cornerRadius = 16
        clipsToBounds = true
    }
}
