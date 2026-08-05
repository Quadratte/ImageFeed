import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ypBlack
        appearance.stackedLayoutAppearance.normal.iconColor = .ypGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.ypGray]
        appearance.stackedLayoutAppearance.selected.iconColor = .ypWhite
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.ypWhite]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

        let imageListVC = ImageListViewController()
        let profileVC = ProfileViewController()

        imageListVC.tabBarItem = UITabBarItem(
            title: nil,
            image: .tabEditorialActive,
            tag: 0
        )

        profileVC.tabBarItem = UITabBarItem(
            title: nil,
            image: .tabProfileActive,
            tag: 1
        )
        setViewControllers([imageListVC, profileVC], animated: true)
    }
}
