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
        setupStatusBar()
        setupNavigationItem()
    }
    
    private func setupStatusBar() {
        navigationController?.setStatusBar(backgroundColor: .systemBlue)
    }
    
    private func setupNavigationItem() {
        let logoImageView = UIImageView(image: .init(named: "Logo"))
        logoImageView.tintColor = .white
        logoImageView.contentMode = .scaleAspectFit
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        logoImageView.frame = titleView.frame
        titleView.addSubview(logoImageView)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBlue
        
        navigationItem.titleView = titleView
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

extension UIViewController: ThemeConfigurable{}

extension UINavigationController {
    fileprivate func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        
        view.addSubview(statusBarView)
    }
}
