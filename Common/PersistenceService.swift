//
//  PersistenceService.swift
//  trello-app1
//
//  Created by Luis Felipe on 22/03/23.
//

import Foundation
import UIKit
import CoreData

protocol PersistenceManager {
    func saveContext()
    func fetchContext(for collection: [AnyObject])
}

public final class PersistenceService: PersistenceManager {
    
    var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func saveContext() {
        do {
            try self.context?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchContext(for collection: [AnyObject]) {
        let fetchRequest = NSFetchRequest<TrelloBoard>(entityName: "TrelloBoard")
        do {
            _ = try context!.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
