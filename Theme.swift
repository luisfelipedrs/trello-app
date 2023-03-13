//
//  Theme.swift
//  trello-app1
//
//  Created by Luis Felipe on 06/02/23.
//

import UIKit

protocol ThemeConfigurable: UIViewController {
    func applyTheme()
}

extension ThemeConfigurable {

    func applyTheme() {
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let logoImageView = UIImageView(image: .init(named: "Logo"))
        logoImageView.tintColor = .white
        logoImageView.contentMode = .scaleAspectFit

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        logoImageView.frame = titleView.frame
        titleView.addSubview(logoImageView)
        navigationItem.titleView = titleView
    }
}

extension UIViewController: ThemeConfigurable {}

extension ThemeConfigurable where Self == UINavigationController {

    func applyTheme() {
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBlue
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }

    init(with rootViewController: UIViewController, thematic: Bool = false) {
        self.init(rootViewController: rootViewController)
        if thematic { applyTheme() }
    }
}

extension ThemeConfigurable where Self == UITabBarController {
    
    func applyTheme() {
        setupTabBar()
    }
    
    private func setupTabBar() {
        view.tintColor = .systemBlue
        self.tabBar.unselectedItemTintColor = .secondaryLabel
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    init(with viewControllers: [UIViewController], thematic: Bool = false) {
        self.init()
        self.viewControllers = viewControllers
        if thematic { applyTheme() }
    }
}
