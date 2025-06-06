//
//  BookRepository.swift
//  BookRadar
//
//  Created by Agata Przykaza on 03/06/2025.
//

import Foundation
import BookAPiKit
import CoreData

class BookRepository: BookRepositoryProtocol{
    
    private let context = CoreDataStack.shared.mainContext
    
    func addBookToLibrary(_ book: BookAPiKit.Book, status: ReadingStatus) async throws -> UserBookEntry {
        
        let existingBook = try findBookItem(by: book.id)
        
        let bookItem: BookItem
        if let existing = existingBook {
            bookItem = existing
        } else {
            bookItem = createBookItem(from: book)
        }
        
        let userEntry = UserBookEntry(context: context)
        userEntry.id = UUID()
        userEntry.book = bookItem
        userEntry.status = status.rawValue
        userEntry.dateAdded = Date()
        userEntry.rating = 0
        userEntry.isFavorite = false
        
        
        try await CoreDataStack.shared.saveAsync()
        
        return userEntry
        
    }
    
    private func findBookItem(by id: String) throws -> BookItem? {
        let request: NSFetchRequest<BookItem> = BookItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        
        return try context.fetch(request).first
    }
    
    private func createBookItem(from book: Book) -> BookItem {
        let bookItem = BookItem(context: context)
        
        
        bookItem.id = book.id
        bookItem.title = book.title
        bookItem.authors = book.authors.joined(separator: ", ")
        bookItem.publishedDate = book.publishedDate
        bookItem.bookDescription = book.description
        bookItem.thumbnailURL = book.thumbnailURL?.absoluteString
        
        return bookItem
    }
    
    func removeBookFromLibrary(_ userEntry: UserBookEntry) async throws {
        
        guard !userEntry.isDeleted else {
            return
        }
        context.delete(userEntry)
        
        try await CoreDataStack.shared.saveAsync()
        
    }
    
    func updateBookStatus(_ userEntry: UserBookEntry, status: ReadingStatus) async throws {
        
        
        let currentStatus = ReadingStatus(rawValue: userEntry.status) ?? .wantToRead
        
        
        userEntry.status = status.rawValue
        
        switch status {
        case .currentlyReading:
            if userEntry.dateStarted == nil {
                userEntry.dateStarted = Date()
            }
            
        case .finished:
            
            if userEntry.dateFinished == nil {
                userEntry.dateFinished = Date()
            }
            
        case .wantToRead, .pause:
            
            userEntry.dateFinished = nil
            
        }
        
        
        try await CoreDataStack.shared.saveAsync()
        
        
        
    }
    
    func updateBookRating(_ userEntry: UserBookEntry, rating: Int16) async throws {
      
        guard userEntry.rating != rating else {
            return
        }
        
        userEntry.rating = rating
        
        try await CoreDataStack.shared.saveAsync()
       
    }
    
    func toggleBookFavorite(_ userEntry: UserBookEntry) async throws {
        userEntry.isFavorite.toggle()
        
        try await CoreDataStack.shared.saveAsync()
    }
    
    func fetchMyBooks() async throws -> [UserBookEntry] {
        let request: NSFetchRequest<UserBookEntry> = UserBookEntry.fetchRequest()
        
       return try context.fetch(request)
    }
    
    func fetchBooks(with status: ReadingStatus) async throws -> [UserBookEntry] {
        let request: NSFetchRequest<UserBookEntry> = UserBookEntry.fetchRequest()
        request.predicate = NSPredicate(format: "status == %@", status.rawValue)
        
        return try context.fetch(request)
    }
    
    func fetchFavoriteBooks() async throws -> [UserBookEntry] {
        let request:NSFetchRequest<UserBookEntry> = UserBookEntry.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == true")
        
        return try context.fetch(request)
    }
    
    func isBookInLibrary(_ id: String) async throws -> UserBookEntry? {
        let request: NSFetchRequest<UserBookEntry> = UserBookEntry.fetchRequest()
        
        request.predicate = NSPredicate(format: "book.id == %@", id)
        request.fetchLimit = 1
        
        return try context.fetch(request).first
    }
    
    func markDayAsRead(for userEntry: UserBookEntry, date: Date) async throws {
        
        let normalizedDate = Calendar.current.startOfDay(for: date)
        
        if let existingReadingDays = userEntry.readingDays as? Set<ReadingDay> {
            let alreadyExists = existingReadingDays.contains { readingDay in
                Calendar.current.isDate(readingDay.date, inSameDayAs: normalizedDate)
            }
            
            if alreadyExists{
                return
            }
        }
        
        let readingDay = ReadingDay(context: context)
        readingDay.id = UUID()
        readingDay.date = normalizedDate
        readingDay.createdAt = Date()
        readingDay.userBookEntry = userEntry
        
        try await CoreDataStack.shared.saveAsync()
        
    }
    
    func unmarkDay(for userEntry: UserBookEntry, date: Date) async throws {
        let normalizedDate = Calendar.current.startOfDay(for: date)
        
        guard let readingDays = userEntry.readingDays as? Set<ReadingDay> else {
            return
        }
        
        if let dayToRemove = readingDays.first(where: {  readingDay in
            Calendar.current.isDate(readingDay.date, inSameDayAs: normalizedDate)
        }){
            userEntry.removeFromReadingDays(dayToRemove)
            context.delete(dayToRemove)
            try await CoreDataStack.shared.saveAsync()
        }
    }
    
    func toggleReadingDay(for userEntry: UserBookEntry, date: Date) async throws -> Bool {
        let normalizedDate = Calendar.current.startOfDay(for: date)
        
     
        
        if let existingReadingDays = userEntry.readingDays as? Set<ReadingDay> {
            let alreadyExists = existingReadingDays.contains { readingDay in
                Calendar.current.isDate(readingDay.date, inSameDayAs: normalizedDate)
            }
            
            if alreadyExists{
                 try await unmarkDay(for: userEntry, date: date)
                return false
            }
        }
        
        try await markDayAsRead(for: userEntry, date: date)
        return true
        
    }
    
    func fetchReadingDays(for userEntry: UserBookEntry, in month: Date) async throws -> [ReadingDay] {
        
        guard let readingDays = userEntry.readingDays as? Set<ReadingDay> else {
            return []
        }
        
        let calendar = Calendar.current
        let monthDays =  readingDays.filter{ readingDay in
            calendar.isDate(readingDay.date, equalTo: month, toGranularity: .month)
        }
        
        return monthDays.sorted{ $0.date < $1.date}
    }
    
    func didReadOnDay(userEntry: UserBookEntry, date: Date) async throws -> Bool {
        guard let readingDays = userEntry.readingDays as? Set<ReadingDay> else {
            return false
        }
        
        let normalizedDate = Calendar.current.startOfDay(for: date)
        
        return readingDays.contains { readingDay in
            Calendar.current.isDate(readingDay.date, inSameDayAs: normalizedDate)
        }
    }
    
    
}
