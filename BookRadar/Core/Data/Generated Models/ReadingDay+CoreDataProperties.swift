//
//  ReadingDay+CoreDataProperties.swift
//  BookRadar
//
//  Created by Agata Przykaza on 03/06/2025.
//
//

import Foundation
import CoreData

extension ReadingDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReadingDay> {
        return NSFetchRequest<ReadingDay>(entityName: "ReadingDay")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var userBookEntry: UserBookEntry

}

extension ReadingDay: Identifiable {

}
