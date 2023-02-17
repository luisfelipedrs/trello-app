//
//  Board.swift
//  trello-app1
//
//  Created by Luis Felipe on 10/02/23.
//

import Foundation

public final class Board {
    var title: String
    var lists: [List]?
    var backgroundImageUrl: URL?
    
    init(title: String, lists: [List]? = nil, backgroundImageUrl: URL? = nil) {
        self.title = title
        self.lists = lists
        self.backgroundImageUrl = backgroundImageUrl
    }
    
    func addList(_ list: List) {
        self.lists?.append(list)
    }
}
