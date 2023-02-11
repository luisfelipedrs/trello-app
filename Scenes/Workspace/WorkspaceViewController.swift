//
//  ViewController.swift
//  trello-app1
//
//  Created by Luis Felipe on 06/02/23.
//

import UIKit

public final class WorkspaceViewController: UIViewController {
    
    var viewModel: WorkspaceViewModel?
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        layout.itemSize = CGSize(width: 200, height: 100)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 16
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(WorkspaceViewCell.self, forCellWithReuseIdentifier: WorkspaceViewCell.reuseId)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        applyTheme()
        configureViews(color: .systemBackground, collection: collectionView)
        configureBackButton()
        viewModel?.getBoards()
    }
}

// MARK: - CollectionView DataSource and Delegate
extension WorkspaceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.boards.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkspaceViewCell.reuseId, for: indexPath) as? WorkspaceViewCell else {
            fatalError()
        }
        let board = viewModel?.boards[indexPath.row]
        cell.board = board
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let listsViewController = ListsViewController()
        listsViewController.viewModel = ListViewModel()
        listsViewController.viewModel?.board = viewModel?.boards[indexPath.row]
        navigationController?.pushViewController(listsViewController, animated: true)
    }
}

// MARK: - CollectionViewFlowLayout
extension WorkspaceViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError()
        }
        
        let itemsPerLine: CGFloat = 2
        let cellProportion: CGFloat = 1/2
        
        let sectionMargins = flowLayout.sectionInset
        let itemsSpacing = flowLayout.minimumInteritemSpacing
        
        let utilArea = collectionView.bounds.width - (sectionMargins.left + sectionMargins.right) - itemsSpacing * (itemsPerLine - 1)
        let itemWidth = utilArea / itemsPerLine
        
        return CGSize(width: itemWidth, height: itemWidth * cellProportion)
    }
}
