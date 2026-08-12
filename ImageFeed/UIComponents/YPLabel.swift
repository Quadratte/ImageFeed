import UIKit

final class YPLabel: UILabel {

    enum YPLabelStyles {
        case primary
        case secondary
    }

    let labelStyle: YPLabelStyles
    let labelColor: UIColor
    let labelText: String?

    init(_ labelStyle: YPLabelStyles, _ labelColor: UIColor, _ labelText: String? = "") {
        self.labelStyle = labelStyle
        self.labelColor = labelColor
        self.labelText = labelText
        super .init(frame: .zero)
        setupLabel()
        applyStyle()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func setupLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        text = labelText
        textColor = labelColor
    }

    private func applyStyle() {
        switch labelStyle {
        case .primary:
            font = .systemFont(ofSize: 23, weight: .bold)
        case .secondary:
            font = .systemFont(ofSize: 13, weight: .regular)
        }
    }
}
