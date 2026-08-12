import UIKit

final class NavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }

    private func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .ypBlack
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.ypWhite,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        appearance.shadowColor = .clear

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = .ypWhite
    }
}
