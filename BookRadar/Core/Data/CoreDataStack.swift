//
//  CoreDataStack.swift
//  BookRadar
//
//  Created by Agata Przykaza on 02/06/2025.
//

import CoreData
import Foundation

final class CoreDataStack{
    
    static let shared = CoreDataStack()
    
    private init(){}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BookRadar")
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                
                print("Core Data Error: \(error)")
                print("Error Info: \(error.userInfo)")
                
#if DEBUG
                fatalError("Core Data failed to load: \(error)")
                
                
#endif
            }
        }
        
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        return container
    }()
    
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    
    @MainActor
    func saveAsync() async throws {
        let context = persistentContainer.viewContext
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Async save failed: \(error)")
            throw error
        }
    }
    
}
