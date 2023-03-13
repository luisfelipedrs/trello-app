//
//  BoardViewCell.swift
//  trello-app1
//
//  Created by Luis Felipe on 08/02/23.
//

import UIKit
import UniformTypeIdentifiers

public final class ListViewCell: UICollectionViewCell {
    
    weak var viewController: UIViewController?
    
    var list: List? {
        didSet {
            guard let list = list else { return }
            setupFor(list: list)
        }
    }
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [listTitleLabel, tableView, button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .white.withAlphaComponent(0.7)
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var listTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .left
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CardViewCell.self, forCellReuseIdentifier: CardViewCell.reuseId)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 5
        return tableView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .small
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0)
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .twilightPurple
        config.attributedTitle = AttributedString("Add new card", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)]))
        
        button.addTarget(self, action: #selector(didTapNewCardButton), for: .touchUpInside)
        
        button.configuration = config
        return button
    }()
    
    @objc private func didTapNewCardButton() {
        let ac = UIAlertController(title: "Enter card title: ", message: nil, preferredStyle: .alert)
            ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            if !answer.text!.isEmpty {
                let newCard = Card(title: answer.text!)
                self.list?.addCard(newCard)
                self.tableView.reloadData()
            }
        }
        
        ac.addAction(submitAction)
        viewController?.present(ac, animated: true)
    }
    
    @objc private func deleteCard(at index: Int) {
        let ac = UIAlertController(title: "Delete card?", message: nil, preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "OK", style: .destructive) { _ in
            self.list?.cards?.remove(at: index)
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        ac.addAction(cancel)
        ac.addAction(confirm)
        viewController?.present(ac, animated: true)
    }
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        tableView.addGestureRecognizer(longPressedGesture)
    }
    
    @objc private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }
        
        let cell = gestureRecognizer.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: cell) {
            deleteCard(at: indexPath.row)
        }
    }
    
// MARK: - ListViewCell Lyfe Cycle
    static var reuseId: String {
        return String(describing: self)
    }
    
    let cellSpacingHeight: CGFloat = 5
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerStackView)
        addConstraints()
        setupLongGestureRecognizerOnCollection()
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    private func setupFor(list: List) {
        listTitleLabel.text = list.title
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

// MARK: - UITableView Delegate and DataSource implementations
extension ListViewCell: UIGestureRecognizerDelegate {}

// MARK: - UITableView Delegate and DataSource implementations
extension ListViewCell: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.cards?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardViewCell.reuseId, for: indexPath) as? CardViewCell else {
            fatalError()
        }
        let card = list?.cards?[indexPath.row]
        cell.card = card
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDragDelegate implementations
extension ListViewCell: UITableViewDragDelegate {
    public func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let list = list, let listData = list.cards?[indexPath.row].title.data(using: .utf8) else {
            return []
        }
        
        let itemProvider = NSItemProvider(item: listData as NSData, typeIdentifier: UTType.utf8PlainText.identifier as String)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        session.localContext = (list, indexPath, tableView)
        
        return [dragItem]
    }
}

// MARK: - UITableViewDropDelegate implementations
extension ListViewCell: UITableViewDropDelegate {
    public func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        if coordinator.session.hasItemsConforming(toTypeIdentifiers: [UTType.utf8PlainText.identifier
 as String]) {
            coordinator.session.loadObjects(ofClass: NSString.self) { (items) in
                guard let string = items.first as? String else { return }
                
                var updatedIndexPaths = [IndexPath]()
                
                switch (coordinator.items.first?.sourceIndexPath, coordinator.destinationIndexPath) {
                case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
                    if sourceIndexPath.row < destinationIndexPath.row {
                        updatedIndexPaths = (sourceIndexPath.row...destinationIndexPath.row).map { IndexPath(row: $0, section: 0) }
                    } else if sourceIndexPath.row > destinationIndexPath.row {
                        updatedIndexPaths = (destinationIndexPath.row...sourceIndexPath.row).map { IndexPath(row: $0, section: 0)}
                    }
                    self.tableView.beginUpdates()
                    self.list?.cards?.remove(at: sourceIndexPath.row)
                    self.list?.cards?.insert(Card(title: string), at: destinationIndexPath.row)
                    self.tableView.reloadRows(at: updatedIndexPaths, with: .automatic)
                    self.tableView.endUpdates()
                    break
                    
                case (nil, .some(let destinationIndexPath)):
                    self.removeSourceTableData(localContext: coordinator.session.localDragSession?.localContext)
                    self.tableView.beginUpdates()
                    self.list?.cards?.insert(Card(title: string), at: destinationIndexPath.row)
                    self.tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                    self.tableView.endUpdates()
                    break
                    
                case (nil, nil):
                    self.removeSourceTableData(localContext: coordinator.session.localDragSession?.localContext)
                    self.tableView.beginUpdates()
                    self.list?.cards?.append(Card(title: string))
                    self.tableView.insertRows(at: [IndexPath(row: (self.list!.cards?.count ?? 0) - 1, section: 0)], with: .automatic)
                    self.tableView.endUpdates()
                    
                default: break
                }
            }
        }
    }
    
    public func removeSourceTableData(localContext: Any?) {
        if let (dataSource, sourceIndexPath, tableView) = localContext as? (List, IndexPath, UITableView) {
            tableView.beginUpdates()
            dataSource.cards?.remove(at: sourceIndexPath.row)
            tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    public func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}


// MARK: - CardViewCell implementations
fileprivate class CardViewCell: UITableViewCell {
    
    static var reuseId: String {
        return String(describing: self)
    }
    
    var card: Card? {
        didSet {
            guard let card = card else { return }
            setupFor(card: card)
        }
    }
    
    private lazy var labelContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var itemLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
// MARK: - CardViewCell Lyfe Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupFor(card: Card) {
        itemLabel.text = card.title
    }
    
    private func setupView() {
        addSubview(labelContainerStackView)
        addConstraints()
        backgroundColor = .clear
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            labelContainerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            labelContainerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelContainerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            labelContainerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
