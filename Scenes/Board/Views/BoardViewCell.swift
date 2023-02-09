//
//  BoardViewCell.swift
//  trello-app1
//
//  Created by Luis Felipe on 08/02/23.
//

import UIKit

public final class BoardViewCell: UICollectionViewCell {
    
    
// MARK: - Cell Lyfe Cycle
    static var reuseId: String {
        return String(describing: self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
