import XCTest

final class ImageFeedUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()

        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))

        let acceptCookies = webView.buttons["Accept all cookies"]
        if acceptCookies.waitForExistence(timeout: 5) {
            acceptCookies.tap()
            sleep(2)
        }


        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        loginTextField.tap()
        sleep(2)
        app.typeText("")


        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        passwordTextField.tap()
        sleep(2)
        passwordTextField.typeText("")

        let loginButton = webView.buttons["Login"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 10))
        loginButton.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()

        let cell = app.tables.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 30))
    }

    func testFeed() throws {
        let cell = app.tables.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 30))

        cell.swipeUp()
        sleep(2)

        let cellToLike = app.tables.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["like button off"].tap()
        cellToLike.buttons["like button on"].tap()
        sleep(2)

        cellToLike.tap()
        sleep(2)

        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        app.buttons["nav back button white"].tap()
    }

    func testProfile() throws {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 30))

        tabBar.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts["Екатерина Новикова"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["@ekaterina_nov"].waitForExistence(timeout: 10))

        app.buttons["logout button"].tap()
        app.alerts.buttons["Да"].tap()
    }
}
