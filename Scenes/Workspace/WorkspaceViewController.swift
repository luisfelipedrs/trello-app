//
//  ViewController.swift
//  trello-app1
//
//  Created by Luis Felipe on 06/02/23.
//

import UIKit
import CoreData

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
        viewModel?.boards = DataManager.shared.boards()
    }
    
    private func setupViews() {
        applyTheme()
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
        addConstraints()
        configureNewBoardButton()
        configureBackButton()
        viewModel?.delegate = self
        setupLongGestureRecognizerOnCollection()
    }
    
    private func configureNewBoardButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewBoard))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc private func addNewBoard() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Enter new board", message: "", preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Create", style: .default) { (action) in
            let board = DataManager.shared.board(title: textField.text ?? "board padrao")
            self.viewModel?.boards.append(board)
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
    
    @objc private func deleteBoard(at indexPath: IndexPath) {
        guard let board = viewModel?.boards[indexPath.row] else {
            fatalError()
        }
        let areYouSureAlert = UIAlertController(title: "Are you sure you want to delete this board?", message: "", preferredStyle: .alert)
        let yesDeleteAction = UIAlertAction(title: "Yes", style: .destructive) { [self] (action) in
            DataManager.shared.deleteBoard(board: board)
            viewModel?.boards.remove(at: indexPath.row)
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
            deleteBoard(at: indexPath)
        }
    }
    
    private func configureBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
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
        listsViewController.viewModel?.api = PhotoApi()
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

// MARK: - WorkSpaceViewModelDelegate
extension WorkspaceViewController: WorkspaceViewModelDelegate {
    func reload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Gesture Recognizer
extension WorkspaceViewController: UIGestureRecognizerDelegate {}
