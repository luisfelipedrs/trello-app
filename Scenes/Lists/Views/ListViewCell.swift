//
//  BoardViewCell.swift
//  trello-app1
//
//  Created by Luis Felipe on 08/02/23.
//

import UIKit

public final class ListViewCell: UICollectionViewCell {
    
    weak var viewController: UIViewController?
    
    var list: List? {
        didSet {
            self.tableView.reloadData()
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
        stackView.backgroundColor = .systemPurple
        return stackView
    }()
    
    private lazy var listTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .pinkishPink
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CardViewCell.self, forCellReuseIdentifier: CardViewCell.reuseId)
        tableView.backgroundColor = .systemPurple
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
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
    
// MARK: - Cell Lyfe Cycle
    static var reuseId: String {
        return String(describing: self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerStackView)
        addConstraints()
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
}

// MARK: - CardTableView implementations
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
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .systemPurple
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var itemLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
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
        addSubview(containerStackView)
        addConstraints()
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
