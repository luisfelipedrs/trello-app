////
////  TabViewController.swift
////  trello-app1
////
////  Created by Luis Felipe on 06/02/23.
////
//
//import UIKit
//
//public final class TabViewController: UITabBarController {
//
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupTabs()
//    }
//
//    private func setupTabs() {
//        // workspace
//        let workspaceViewController = WorkspaceViewController()
//        workspaceViewController.viewModel = WorkspaceViewModel()
//        let workspaceNavigationController = UINavigationController(rootViewController: workspaceViewController)
//
//        // home
//        let homeNavigationController = UINavigationController(rootViewController: HomeViewController())
//
//        // search
//        let searchNavigationController = UINavigationController(rootViewController: SearchViewController())
//
//        // notifications
//        let notificationNavigationController = UINavigationController(rootViewController: NotificationViewController())
//
//        // account
//        let accountNavigationController = UINavigationController(rootViewController: AccountViewController())
//
//        // setup
//        workspaceNavigationController.tabBarItem.image = UIImage(systemName: "square.and.arrow.down.fill")
//        homeNavigationController.tabBarItem.image = UIImage(systemName: "house.fill")
//        searchNavigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
//        notificationNavigationController.tabBarItem.image = UIImage(systemName: "bell.fill")
//        accountNavigationController.tabBarItem.image = UIImage(systemName: "person.fill")
//
//        workspaceNavigationController.title = "Workspace"
//        homeNavigationController.title = "Home"
//        searchNavigationController.title = "Search"
//        notificationNavigationController.title = "Notifications"
//        accountNavigationController.title = "Account"
//
//        tabBar.tintColor = .systemBlue
//        tabBar.unselectedItemTintColor = .secondaryLabel
//
//        tabBar.layer.borderWidth = 0.50
//        tabBar.layer.borderColor = UIColor.lightGray.cgColor
//
//        setViewControllers([workspaceNavigationController,
//                            homeNavigationController,
//                            searchNavigationController,
//                            notificationNavigationController,
//                            accountNavigationController], animated: true)
//    }
//}
