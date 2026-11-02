import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func setLike(_ isLiked: Bool, at indexPath: IndexPath)
    func showSingleImage(with url: URL?)
}

final class ImageListViewController: UIViewController {

    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypBlack
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.id)
        return tableView
    }()

    // MARK: - Properties
    var presenter: ImagesListPresenterProtocol?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupTableView()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Configure
    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }

    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .ypBlack
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.photosCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.id, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell,
              let presenter else {
            return UITableViewCell()
        }

        let photo = presenter.photo(at: indexPath)
        let imageURL = URL(string: photo.thumbImageURL)
        let date = photo.createdAt.map { DateFormatter.ruRuDate.string(from: $0) } ?? ""

        imageListCell.delegate = self
        imageListCell.configure(imageURL: imageURL, date: date, isLiked: photo.isLiked)
        return imageListCell
    }
}

// MARK: - UITableViewDelegate
extension ImageListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchNextPageIfNeeded(at: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.photo(at: indexPath) else { return 200 }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width

        guard imageWidth > 0 else { return 200 }

        let scale = imageViewWidth / imageWidth
        return photo.size.height * scale + imageInsets.top + imageInsets.bottom
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectRow(at: indexPath)
    }
}

// MARK: - ImagesListCellDelegate
extension ImageListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.didTapLike(at: indexPath)
    }
}

// MARK: - ImagesListViewControllerProtocol
extension ImageListViewController: ImagesListViewControllerProtocol {

    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }

    func setLike(_ isLiked: Bool, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return }
        cell.setIsLiked(isLiked)
    }

    func showSingleImage(with url: URL?) {
        let singleImageVC = SingleImageViewController()
        singleImageVC.imageURL = url
        present(singleImageVC, animated: true)
    }
}

// MARK: - DateFormatter
private extension DateFormatter {
    static let ruRuDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
}
