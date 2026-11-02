import UIKit

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLike(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
    func fetchNextPageIfNeeded(at indexPath: IndexPath)
    var photosCount: Int { get }
    func photo(at indexPath: IndexPath) -> Photo
}

import Foundation

final class ImagesListPresenter: ImagesListPresenterProtocol {

    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService: ImagesListService
    private var imagesListServiceObserver: NSObjectProtocol?
    private(set) var photos: [Photo] = []

    init(imagesListService: ImagesListService = .shared) {
        self.imagesListService = imagesListService
    }

    var photosCount: Int { photos.count }

    func photo(at indexPath: IndexPath) -> Photo {
        photos[indexPath.row]
    }

    func viewDidLoad() {
        addObserver()
        imagesListService.fetchPhotosNextPage()
    }

    func fetchNextPageIfNeeded(at indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }

    func didTapLike(at indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let isLike = !photo.isLiked

        UIBlockingProgressHUD.show()

        imagesListService.changeLike(photoId: photo.id, isLike: isLike) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }

            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                self.view?.setLike(self.photos[indexPath.row].isLiked, at: indexPath)
            case .failure(let error):
                print("[didTapLike]: \(error.localizedDescription)")
            }
        }
    }

    func didSelectRow(at indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let url = URL(string: photo.largeImageURL)
        view?.showSingleImage(with: url)
    }

    private func addObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            let oldCount = self.photos.count
            let newCount = self.imagesListService.photos.count
            self.photos = self.imagesListService.photos

            if oldCount != newCount {
                self.view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
            }
        }
    }
}
