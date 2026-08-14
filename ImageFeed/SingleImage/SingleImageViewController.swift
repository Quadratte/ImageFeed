import UIKit

final class SingleImageViewController: UIViewController {

    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.minimumZoomScale = 0.1
        sv.maximumZoomScale = 1.25
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()

    private let imageView = YPImageView()
    private let backButton = YPButton(.backward)
    private let shareButton = YPButton(.sharing)

    var image: UIImage?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupActions()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateZoomScale()
    }

    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .ypBlack
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(backButton)
        view.addSubview(shareButton)

        scrollView.delegate = self
        imageView.image = image
        backButton.tintColor = .ypWhite
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 44),

            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
        ])
    }

    private func setupActions() {
        backButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)

        shareButton.addAction(UIAction { [weak self] _ in
            self?.didTapShareButton()
        }, for: .touchUpInside)
    }

    // MARK: - UIActivityViewController

    private func didTapShareButton() {
        guard let existImage = image else { return }

        let activityVC = UIActivityViewController(activityItems: [existImage], applicationActivities: nil)
        present(activityVC, animated: true)
    }

    // MARK: - Zoom & Center
    private func updateZoomScale() {
        scrollView.layoutIfNeeded()
        guard let image = image,
              scrollView.bounds.width > 0,
              scrollView.bounds.height > 0 else { return }

        let scrollViewSize = scrollView.bounds.size
        let imageSize = image.size

        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height

        let minScale = min(widthScale, heightScale)
        let maxScale = max(widthScale, heightScale)

        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = maxScale
        centerImage()
    }

    private func centerImage() {
        let scrollViewSize = scrollView.bounds.size
        let contentSize = scrollView.contentSize

        guard scrollViewSize.width > 0, scrollViewSize.height > 0,
              contentSize.width > 0, contentSize.height > 0 else { return }

        let verticalInset = max(0, (scrollViewSize.height - contentSize.height) / 2)
        let horizontalInset = max(0, (scrollViewSize.width - contentSize.width) / 2)

        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )

        let offsetX = -horizontalInset + (contentSize.width - scrollViewSize.width) / 2
        let offsetY = -verticalInset + (contentSize.height - scrollViewSize.height) / 2

        scrollView.contentOffset = CGPoint(x: offsetX, y: offsetY)
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
