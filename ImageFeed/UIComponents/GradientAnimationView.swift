import UIKit

final class GradientAnimationView: UIView {

    // MARK: - Properties
    private var animationLayers = Set<CALayer>()
    private let gradientLayer = CAGradientLayer()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    // MARK: - Setup
    private func setupGradient() {
        gradientLayer.locations = [0, 0.1, 0.3]
        gradientLayer.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        layer.addSublayer(gradientLayer)
        animationLayers.insert(gradientLayer)

        addAnimation()
    }

    private func addAnimation() {
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradientLayer.add(gradientChangeAnimation, forKey: "locationsChange")
    }

    // MARK: - Clean
    func removeAnimation() {
        animationLayers.forEach { $0.removeFromSuperlayer() }
        animationLayers.removeAll()
    }
}
