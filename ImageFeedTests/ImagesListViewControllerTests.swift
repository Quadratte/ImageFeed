import XCTest
@testable import ImageFeed

final class ImagesListViewControllerTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        let viewController = ImageListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)

        _ = viewController.view

        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}
