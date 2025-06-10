//
//  BookRadarApp.swift
//  BookRadar
//
//  Created by Agata Przykaza on 30/05/2025.
//

import SwiftUI
import CoreData

extension EnvironmentValues {
    @Entry var bookRepository: BookRepositoryProtocol = BookRepository()
}

@main
struct BookRadarApp: App {
    
    let coreDataStack = CoreDataStack.shared
    let bookRepository = BookRepository()
    init() {
        print(NSPersistentContainer.defaultDirectoryURL())
        

    }
    
    var body: some Scene {
        WindowGroup {
            TabsView()
                .environment(\.managedObjectContext, coreDataStack.mainContext)
                .environment(\.bookRepository, bookRepository)
        }
    }
}
