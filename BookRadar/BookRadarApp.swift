//
//  BookRadarApp.swift
//  BookRadar
//
//  Created by Agata Przykaza on 30/05/2025.
//

import SwiftUI
import CoreData

@main
struct BookRadarApp: App {
    
    let coreDataStack = CoreDataStack.shared
    
//    init(){
//        print(NSPersistentContainer.defaultDirectoryURL())
//    }
    
    var body: some Scene {
        WindowGroup {
            SimpleRepositoryTest()
                .environment(\.managedObjectContext, coreDataStack.mainContext)
        }
    }
}
