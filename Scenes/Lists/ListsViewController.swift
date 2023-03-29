//
//  BoardViewController.swift
//  trello-app1
//
//  Created by Luis Felipe on 08/02/23.
//

import UIKit
import CoreData

public final class ListsViewController: UIViewController {
    
    var viewModel: ListViewModel?
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = viewModel?.board?.trelloList?.count ?? 0
        pageControl.backgroundStyle = .prominent
        pageControl.isHidden = (viewModel?.board?.trelloList?.count ?? 0) > 1 ? false : true
        return pageControl
    }()
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ListViewCell.self, forCellWithReuseIdentifier: ListViewCell.reuseId)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var alphaLayer: UIView = {
        let alphaLayer = UIView()
        alphaLayer.translatesAutoresizingMaskIntoConstraints = false
        alphaLayer.backgroundColor = .white.withAlphaComponent(0.5)
        return alphaLayer
    }()
    
//    private lazy var alphaLayer: CALayer = {
//        let alphaLayer = CALayer()
//        alphaLayer.frame = backgroundImage.frame
//        alphaLayer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor
//        return alphaLayer
//    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.backgroundColor = .systemBackground
        addConstraints()
        viewModel?.delegate = self
        configureTitleWith(string: (viewModel?.board!.title)!)
        configureNewListButton()
        viewModel?.getBackgroudImageUrl()
        setupLongGestureRecognizerOnCollection()
        collectionView.backgroundView = backgroundImage
    }
    
    private func updateViews() {
        self.pageControl.numberOfPages = self.viewModel?.board?.trelloList?.count ?? 0
        self.pageControl.isHidden = (self.viewModel?.board?.trelloList?.count ?? 0) > 1 ? false : true
        self.collectionView.reloadData()
    }
    
    private func configureNewListButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewList))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc private func addNewList() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Enter new list", message: "", preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Create", style: .default) { (action) in
            let list = DataManager.shared.list(title: textField.text ?? "lista padrao", board: (self.viewModel?.board)!)
            self.viewModel?.board?.addToTrelloList(list)
            DataManager.shared.save()
            self.reload()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: Board 1"
            textField = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true)
        }
        
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc private func deleteList(at indexPath: IndexPath) {
        guard let list = viewModel?.board?.trelloList?[indexPath.row] else {
            fatalError()
        }
        let areYouSureAlert = UIAlertController(title: "Are you sure you want to delete this list?", message: "", preferredStyle: .alert)
        let yesDeleteAction = UIAlertAction(title: "Yes", style: .destructive) { [self] (action) in
            DataManager.shared.deleteList(list: list as! TrelloList)
            self.viewModel?.board?.removeFromTrelloList(list as! TrelloList)
            collectionView.deleteItems(at: [indexPath])
            self.reload()
        }
        
        let noDeleteAction = UIAlertAction(title: "No", style: .default) { (action) in
        }
        
        areYouSureAlert.addAction(noDeleteAction)
        areYouSureAlert.addAction(yesDeleteAction)
        self.present(areYouSureAlert, animated: true)
    }
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPressedGesture)
    }
    
    @objc private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }
        
        let cell = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: cell) {
            deleteList(at: indexPath)
            self.reload()
        }
    }
    
    private func configureTitleWith(string: String) {
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
    
    private func addConstraints() {
        NSLayoutConstraint.activate([pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                                     
                                     collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
}

// MARK: - CollectionView DataSource and Delegate
extension ListsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.board?.trelloList?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListViewCell.reuseId, for: indexPath) as? ListViewCell else {
            fatalError()
        }
        
        let list = viewModel?.board?.trelloList?[indexPath.row]
        cell.list = list as? TrelloList
        cell.viewController = self
        return cell
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        var indexes = collectionView.indexPathsForVisibleItems
        indexes.sort()
        var index = indexes.first!
        let cell = collectionView.cellForItem(at: index)!
        let position = collectionView.contentOffset.x - cell.frame.origin.x
        if position > cell.frame.size.width / 2 {
           index.row = index.row + 1
        }
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true )
        pageControl.currentPage = index.item
    }
}

// MARK: - CollectionViewFlowLayout
extension ListsViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError()
        }

        let itemsPerLine: CGFloat = 1
        let cellProportion: CGFloat = 40/25

        let sectionMargins = flowLayout.sectionInset
        let itemsSpacing = flowLayout.minimumInteritemSpacing

        let utilArea = collectionView.bounds.width - (sectionMargins.left + sectionMargins.right) - itemsSpacing * (itemsPerLine - 1)
        let itemWidth = utilArea / itemsPerLine

        return CGSize(width: itemWidth, height: itemWidth * cellProportion)
    }
}

// MARK: - ViewModelDelegate implementations
extension ListsViewController: ListViewModelDelegate {
    func loadBackgroundImage() {
        backgroundImage.setImageByDowloading(url: (viewModel?.board?.backgroundImageUrl)!)
    }
    
    func reload() {
        updateViews()
    }
}

// MARK: - Gesture Recognizer
extension ListsViewController: UIGestureRecognizerDelegate {}
