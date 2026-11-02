import XCTest
@testable import ImageFeed

final class ProfileViewControllerTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter)

        _ = viewController.view

        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}
