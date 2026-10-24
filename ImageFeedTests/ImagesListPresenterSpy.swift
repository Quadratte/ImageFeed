import UIKit
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled = false
    var fetchNextPageCalled = false
    var didTapLikeCalled = false
    var didSelectRowCalled = false
    var photosCount = 0

    func viewDidLoad() { viewDidLoadCalled = true }
    func fetchNextPageIfNeeded(at indexPath: IndexPath) { fetchNextPageCalled = true }
    func didTapLike(at indexPath: IndexPath) { didTapLikeCalled = true }
    func didSelectRow(at indexPath: IndexPath) { didSelectRowCalled = true }
    func photo(at indexPath: IndexPath) -> Photo {
        Photo(
            id: "1",
            size: .zero,
            createdAt: nil,
            welcomeDescription: nil,
            thumbImageURL: "",
            largeImageURL: "",
            isLiked: false
        )
    }
}
