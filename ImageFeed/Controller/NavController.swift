import UIKit

final class NavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }

    private func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .ypBlack

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
}
