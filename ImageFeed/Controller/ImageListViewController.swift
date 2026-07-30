import UIKit

class ImageListViewController: UITableViewController {

    private let photosName: [String] = Array(0..<20).map { "\($0)"}

    init() {
        super.init(style: .grouped)
        setupTable()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.id)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .ypBlack
        tableView.estimatedRowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {

        guard let image = UIImage(named: "\(indexPath.row)") else { return }

        cell.cardImage.image = image
        cell.cardlabel.text = Date.now.formatted(date: .long, time: .omitted)

        let isLiked = indexPath.row % 2 == 0
        cell.favoriteButton.setImage(isLiked ? .inactive : .active, for: .normal)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.id, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
