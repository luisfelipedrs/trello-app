//
//  ConfigureViewController.swift
//  trello-app1
//
//  Created by Luis Felipe on 08/02/23.
//

import UIKit

extension UIViewController {
    
    func configureViews(color: UIColor? = nil,
                        collection collectionView: UICollectionView? = nil,
                        scroll scrollView: UIScrollView? = nil) {
        
        view.backgroundColor = color
        
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
        
        guard let scrollView = scrollView else { return }
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     scrollView.widthAnchor.constraint(equalToConstant: 1000),
                                     scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    func configureBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    func configureTitleWith(string: String) {
        let titleLabel = UILabel()
        titleLabel.text = string
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 44))
        titleLabel.frame = titleView.frame
        titleView.addSubview(titleLabel)
        
        navigationItem.titleView = titleView
    }
}
