//
//  BookItem+CoreDataProperties.swift
//  BookRadar
//
//  Created by Agata Przykaza on 03/06/2025.
//
//

import Foundation
import CoreData

extension BookItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookItem> {
        return NSFetchRequest<BookItem>(entityName: "BookItem")
    }

    @NSManaged public var authors: String
    @NSManaged public var bookDescription: String?
    @NSManaged public var id: String
    @NSManaged public var publishedDate: String?
    @NSManaged public var thumbnailURL: String?
    @NSManaged public var title: String
    @NSManaged public var userEntries: NSSet?

}

// MARK: Generated accessors for userEntries
extension BookItem {

    @objc(addUserEntriesObject:)
    @NSManaged public func addToUserEntries(_ value: UserBookEntry)

    @objc(removeUserEntriesObject:)
    @NSManaged public func removeFromUserEntries(_ value: UserBookEntry)

    @objc(addUserEntries:)
    @NSManaged public func addToUserEntries(_ values: NSSet)

    @objc(removeUserEntries:)
    @NSManaged public func removeFromUserEntries(_ values: NSSet)

}

extension BookItem: Identifiable {

}
