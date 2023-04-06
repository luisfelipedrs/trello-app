//
//  Navigation.swift
//  trello-app1
//
//  Created by Luis Felipe on 28/02/23.
//

import UIKit

enum Tab {
    case workspace
    case home
    
    var item: UITabBarItem {
        switch self {
        case .workspace:
            return UITabBarItem(title: "Workspace", image: UIImage(systemName: "square.and.arrow.down"), selectedImage: UIImage(systemName: "square.and.arrow.down.fill"))
        case .home:
            return UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        }
    }
}

protocol ControllerFactory {
    func build() -> UIViewController
}

final class WorkspaceNavigationFactory: ControllerFactory {
    func build() -> UIViewController {
        
        let workspaceViewController = WorkspaceViewController()
        workspaceViewController.viewModel = WorkspaceViewModel()
        
        return UINavigationController(with: workspaceViewController, thematic: true)
    }
}

final class HomeNavigationFactory: ControllerFactory {
    func build() -> UIViewController {
        let homeViewController = HomeViewController()
        
        return UINavigationController(with: homeViewController, thematic: true)
    }
}

final class TabBarFactory: ControllerFactory {
    
    typealias TabContext = KeyValuePairs<Tab, any ControllerFactory>
    
    var tabs: TabContext
    
    init(for tabs: TabContext) {
        self.tabs = tabs
    }
    
    func build() -> UIViewController {
        let controllers = tabs.enumerated().map { (index, entry) in
            let (tab, factory) = entry
            let controller = factory.build()
            let tabItem = tab.item
            tabItem.tag = index
            controller.tabBarItem = tabItem
            return controller
        }
        
        return UITabBarController(with: controllers, thematic: true)
    }
}
