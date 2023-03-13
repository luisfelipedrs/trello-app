//
//  BoardViewController.swift
//  trello-app1
//
//  Created by Luis Felipe on 08/02/23.
//

import UIKit
import Kingfisher

public final class ListsViewController: UIViewController {
    
    var viewModel: ListViewModel?
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = viewModel?.board?.lists?.count ?? 0
        pageControl.backgroundStyle = .prominent
        pageControl.isHidden = (viewModel?.board?.lists?.count ?? 0) > 1 ? false : true
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
        return collectionView
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        configureViews(color: .systemBackground, collection: collectionView)
        viewModel?.delegate = self
        viewModel?.viewModelDelegate = self
        configureBackButton()
        configurePageControl()
        configureTitleWith(string: (viewModel?.board!.title)!)
        configureNewListButton()
        viewModel?.getLists()
        viewModel?.getBackgroudImageUrl()
        setupLongGestureRecognizerOnCollection()
        collectionView.backgroundView = backgroundImage
    }
    
    private func configurePageControl() {
        view.addSubview(pageControl)
        addConstraints()
    }
    
    private func updateViews() {
        self.collectionView.reloadData()
        self.pageControl.numberOfPages = self.viewModel?.board?.lists?.count ?? 0
        self.pageControl.isHidden = (self.viewModel?.board?.lists?.count ?? 0) > 1 ? false : true
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)])
    }
    
    private func configureNewListButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewList))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc private func addNewList() {
        let ac = UIAlertController(title: "Enter list title: ", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            if !answer.text!.isEmpty {
                let newList = List(title: answer.text!, cards: [])
                self.viewModel?.addList(newList)
            }
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc private func deleteList(at index: Int) {
        let ac = UIAlertController(title: "Delete list?", message: nil, preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "OK", style: .destructive) { _ in
            self.viewModel?.board?.lists?.remove(at: index)
            self.updateViews()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        ac.addAction(cancel)
        ac.addAction(confirm)
        present(ac, animated: true)
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
            deleteList(at: indexPath.row)
        }
    }
}

// MARK: - CollectionView DataSource and Delegate
extension ListsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.board?.lists?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListViewCell.reuseId, for: indexPath) as? ListViewCell else {
            fatalError()
        }
        
        let list = viewModel?.board?.lists?[indexPath.row]
        cell.list = list
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

// MARK: - DataReloadDelegate implementation
extension ListsViewController: DataReloadDelegate {
    func reload() {
        updateViews()
    }
}

// MARK: - ViewModelDelegate implementations
extension ListsViewController: ListViewModelDelegate {
    func loadBackgroundImage() {
        backgroundImage.setImageByDowloading(url: (viewModel?.board?.backgroundImageUrl)!)
    }
}

// MARK: - Gesture Recognizer
extension ListsViewController: UIGestureRecognizerDelegate {}
