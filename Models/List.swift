//
//  List.swift
//  trello-app1
//
//  Created by Luis Felipe on 10/02/23.
//

import Foundation

class List {
    var title: String
    var cards: [Card]?
    
    init(title: String, cards: [Card]? = nil) {
        self.title = title
        self.cards = cards
    }
    
    func addCard(_ card: Card) {
        self.cards?.append(card)
    }
}
