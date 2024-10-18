//
//  SceneDelegate.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 28.09.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let categoryVC = CategoryViewController()
        let cartVC = CartViewController()

        let navigationController = UINavigationController(rootViewController: categoryVC)
        
        categoryVC.tabBarItem = UITabBarItem(title: "Categories",
                                             image: UIImage(systemName: "magnifyingglass.circle"),
                                             selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        cartVC.tabBarItem = UITabBarItem(title: "Cart",
                                         image: UIImage(systemName: "cart"),
                                         selectedImage: UIImage(systemName: "cart.fill"))
        
        let tabBarController = CustomTabBarController()
        tabBarController.setViewControllers([navigationController, cartVC], animated: true)

        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }
}

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor =  UIColor(named: "background")?.withAlphaComponent(0.8)
        

        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray]

        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance

        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.masksToBounds = false
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        
        let tabBarItemViews = tabBar.subviews.filter { $0 is UIControl }
        let selectedView = tabBarItemViews[index]
        
        UIView.animate(withDuration: 0.3, animations: {
            selectedView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                selectedView.transform = CGAffineTransform.identity
            }
        }
    }
}
