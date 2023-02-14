//
//  Board.swift
//  trello-app1
//
//  Created by Luis Felipe on 10/02/23.
//

import Foundation

class Board {
    var title: String
    var lists: [List]?
    
    init(title: String, lists: [List]? = nil) {
        self.title = title
        self.lists = lists
    }
    
    func addList(_ list: List) {
        self.lists?.append(list)
    }
}
