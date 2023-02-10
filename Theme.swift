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
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBlue
        
        navigationItem.titleView = titleView
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

extension UIViewController: ThemeConfigurable{}
