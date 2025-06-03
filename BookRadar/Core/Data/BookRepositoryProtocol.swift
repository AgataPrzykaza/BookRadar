//
//  BookRepositoryProtocol.swift
//  BookRadar
//
//  Created by Agata Przykaza on 02/06/2025.
//

import Foundation
import BookAPiKit

protocol BookRepositoryProtocol {
    
    func addBookToLibrary(_ book: Book,status: ReadingStatus) async throws -> UserBookEntry
    
    func removeBookFromLibrary(_ userEntry: UserBookEntry) async throws
    
    func updateBookStatus(_ userEntry: UserBookEntry, status: ReadingStatus) async throws
    
    func updateBookRating(_ userEntry: UserBookEntry, rating: Int16) async throws
    
    func toggleBookFavorite(_ userEntry: UserBookEntry) async throws
    
    
    
    func fetchMyBooks() async throws -> [UserBookEntry]
    func fetchBooks(with status: ReadingStatus) async throws -> [UserBookEntry]
    func fetchFavoriteBooks() async throws -> [UserBookEntry]
    func isBookInLibrary(_ id: String) async throws -> Bool
    
    func markDayAsRead(for userEntry: UserBookEntry, date: Date) async throws
    func unmarkDay(for userEntry: UserBookEntry, date: Date) async throws
    func toggleReadingDay(for userEntry: UserBookEntry, date: Date) async throws -> Bool
    func fetchReadingDays(for userEntry: UserBookEntry, in month: Date) async throws -> [ReadingDay]
    func didReadOnDay(userEntry: UserBookEntry, date: Date) async throws -> Bool
}

enum ReadingStatus: String, CaseIterable {
    case wantToRead = "want_to_read"
    case currentlyReading = "currently_reading"
    case finished = "finished"
    case onHold = "on_hold"
    
    var displayName: String {
        switch self {
        case .wantToRead: return "Want to Read"
        case .currentlyReading: return "Currently Reading"
        case .finished: return "Finished"
        case .onHold: return "On Hold"
        }
    }
}
