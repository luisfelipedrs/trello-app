//
//  BoardViewModel.swift
//  trello-app1
//
//  Created by Luis Felipe on 10/02/23.
//

import Foundation

public final class ListViewModel {
    
    var board: Board? {
        didSet {
            guard let board = board else { return }
            guard let lists = board.lists else { return }
            self.lists = lists
        }
    }
    
    var lists: [List] = []
}
