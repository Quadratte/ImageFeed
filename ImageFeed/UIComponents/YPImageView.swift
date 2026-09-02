import UIKit

final class YPImageView: UIImageView {

    enum YPImageStyles {
        case normal
        case rounded
    }

    var withImage: UIImage?
    var imageStyle: YPImageStyles

    init(_ withImage: UIImage? = nil, _ imageStyle: YPImageStyles = .normal) {
        self.withImage = withImage
        self.imageStyle = imageStyle
        super .init(frame: .zero)
        setupImage()
    }

    init(_ imageStyle: YPImageStyles = .normal) {
        self.imageStyle = imageStyle
        super .init(frame: .zero)
        setupImage()
        applyStyles()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupImage() {
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        image = withImage
    }

    private func applyStyles() {
        switch imageStyle {
        case .normal:
            layer.cornerRadius = 0
        case .rounded:
            layer.cornerRadius = 16
            clipsToBounds = true
        }
    }
}
