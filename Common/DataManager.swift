//
//  DataManager.swift
//  trello-app1
//
//  Created by Luis Felipe on 28/03/23.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrelloModel")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func board(title: String) -> TrelloBoard {
        let board = TrelloBoard(context: persistentContainer.viewContext)
        board.title = title
        return board
    }
    
    func list(title: String, board: TrelloBoard) -> TrelloList {
        let list = TrelloList(context: persistentContainer.viewContext)
        list.title = title
        board.addToTrelloList(list)
        return list
    }
    
    func card(title: String, list: TrelloList) -> TrelloCard {
        let card = TrelloCard(context: persistentContainer.viewContext)
        card.title = title
        list.addToTrelloCard(card)
        return card
    }
    
    func boards() -> [TrelloBoard] {
        let request: NSFetchRequest<TrelloBoard> = TrelloBoard.fetchRequest()
        var fetchedBoards: [TrelloBoard] = []
        
        do {
            fetchedBoards = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching boards \(error)")
        }
        
        return fetchedBoards
    }
    
    func lists(board: TrelloBoard) -> [TrelloList] {
        let request: NSFetchRequest<TrelloList> = TrelloList.fetchRequest()
        var fetchedLists: [TrelloList] = []
        
        do {
            fetchedLists = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching lists \(error)")
        }
        
        return fetchedLists
    }
    
    func cards(list: TrelloList) -> [TrelloCard] {
        let request: NSFetchRequest<TrelloCard> = TrelloCard.fetchRequest()
        var fetchedCards: [TrelloCard] = []
        
        do {
            fetchedCards = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching lists \(error)")
        }
        
        return fetchedCards
    }
    
    func deleteBoard(board: TrelloBoard) {
        let context = persistentContainer.viewContext
        context.delete(board)
        save()
    }
    
    func deleteList(list: TrelloList) {
        let context = persistentContainer.viewContext
        context.delete(list)
        save()
    }
    
    func deleteCard(card: TrelloCard) {
        let context = persistentContainer.viewContext
        context.delete(card)
        save()
    }
    
    // Core Data Saving Support
    func save() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
