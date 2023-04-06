//
//  Coordinator.swift
//  trello-app1
//
//  Created by Luis Felipe on 30/03/23.
//

import UIKit

//protocol Coordinator {
//    func start()
//    func coordinate(to coordinator: Coordinator)
//}
//
//extension Coordinator {
//    func coordinate(to coordinator: Coordinator) {
//        coordinator.start()
//    }
//}

protocol Coordinator {
    func start()
}

class MyCoordinator: Coordinator {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabBarController = TabBarFactory(for: [.workspace: WorkspaceNavigationFactory(),
                                                   .home: HomeNavigationFactory()])

        window.rootViewController = tabBarController.build()
    }
}
