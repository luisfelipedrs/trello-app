//
//  BoardViewModel.swift
//  trello-app1
//
//  Created by Luis Felipe on 10/02/23.
//

import Foundation

public final class ListViewModel {
    
    weak var delegate: DataReloadDelegate?
    
    var board: Board?
    
    func getLists() {
        guard let boardLists = board?.lists else { return }
        board?.lists = boardLists
    }
    
    func addList(_ list: List) {
        self.board?.addList(list)
        self.delegate?.reload()
    }
}
