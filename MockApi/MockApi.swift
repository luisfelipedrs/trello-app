//
//  File.swift
//  trello-app1
//
//  Created by Luis Felipe on 10/02/23.
//

import Foundation

public final class MockApi {
    
    static func getBoads() -> [Board] {
        return [
            Board(title: "board 1", lists: [List(title: "list 1", cards: [Card(title: "card 1"),
                                                                          Card(title: "card 2"),
                                                                          Card(title: "card 3")]),
                                            List(title: "list 2", cards: [Card(title: "card 1"),
                                                                          Card(title: "card 2"),
                                                                          Card(title: "card 3")])]),
            
            Board(title: "board 2", lists: [List(title: "list 1", cards: [Card(title: "card 1"),
                                                                          Card(title: "card 2"),
                                                                          Card(title: "card 3")])]),
            
            Board(title: "board 3", lists: [List(title: "list 1", cards: [Card(title: "card 1"),
                                                                          Card(title: "card 2"),
                                                                          Card(title: "card 3")])]),
        ]
    }
}
