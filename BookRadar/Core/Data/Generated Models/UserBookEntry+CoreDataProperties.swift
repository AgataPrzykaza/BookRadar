//
//  UserBookEntry+CoreDataProperties.swift
//  BookRadar
//
//  Created by Agata Przykaza on 03/06/2025.
//
//

import Foundation
import CoreData


extension UserBookEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserBookEntry> {
        return NSFetchRequest<UserBookEntry>(entityName: "UserBookEntry")
    }

    @NSManaged public var dateAdded: Date
    @NSManaged public var dateFinished: Date?
    @NSManaged public var dateStarted: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var personalNotes: String?
    @NSManaged public var rating: Int16
    @NSManaged public var status: String
    @NSManaged public var book: BookItem?
    @NSManaged public var readingDays: NSSet?

}

// MARK: Generated accessors for readingDays
extension UserBookEntry {

    @objc(addReadingDaysObject:)
    @NSManaged public func addToReadingDays(_ value: ReadingDay)

    @objc(removeReadingDaysObject:)
    @NSManaged public func removeFromReadingDays(_ value: ReadingDay)

    @objc(addReadingDays:)
    @NSManaged public func addToReadingDays(_ values: NSSet)

    @objc(removeReadingDays:)
    @NSManaged public func removeFromReadingDays(_ values: NSSet)

}

extension UserBookEntry : Identifiable {

}
