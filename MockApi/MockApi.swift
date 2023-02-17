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
            Board(title: "trello app", lists: [List(title: "todo",
                                                    cards: [Card(title: "sincronização de dados"),
                                                            Card(title: "ajustar tableview para sections ao invés de rows"),
                                                            Card(title: "ajustar views para device em landscape")]),
                                               
                                               List(title: "in progress",
                                                    cards: [Card(title: "ajustar altura da tableview q ta dificil"),                    Card(title: "ajustar background da tableview")]),
                                               
                                               List(title: "done",
                                                    cards: [Card(title: "criar/deletar boards, listas e cards"),
                                                            Card(title: "drag and drop"),
                                                            Card(title: "imagem de background vindo da api da NASA")])]),
            
            Board(title: "board 2", lists: [List(title: "list 1",
                                                 cards: [Card(title: "card 1"),
                                                         Card(title: "card 2"),
                                                         Card(title: "card 3")])]),
            
            Board(title: "board 3", lists: [List(title: "list 1",
                                                 cards: [Card(title: "card 1"),
                                                         Card(title: "card 2"),
                                                         Card(title: "card 3")])]),
        ]
    }
}
