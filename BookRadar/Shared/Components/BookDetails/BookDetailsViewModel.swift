//
//  BookDetailsViewModel.swift
//  BookRadar
//
//  Created by Agata Przykaza on 09/06/2025.
//

import SwiftUI
import BookAPiKit

@MainActor
@Observable
class BookDetailsViewModel {
    
    private var bookRepository: BookRepositoryProtocol
    
    var isLoading = false
    var message: String?
    var userBookEntry: UserBookEntry?
    var currentStatus: ReadingStatus? {
        didSet {
            
            if let newStatus = currentStatus, newStatus != oldValue {
                Task {
                    await updateStatus(newStatus)
                }
            }
        }
    }
    
    init(bookRepository: BookRepositoryProtocol) {
        self.bookRepository = bookRepository
    }
    
    func updateStatus(_ newStatus: ReadingStatus) async {
        guard userBookEntry != nil else { return }
        
        userBookEntry?.status = newStatus.rawValue
        currentStatus = newStatus
        
        do {
            
            try await bookRepository.updateBookStatus(userBookEntry!, status: newStatus)
            
            message = "Status zaktualizowany! dla \(newStatus.displayName)"
        } catch {
            message = "Błąd: \(error.localizedDescription)"
        }
    }
    
    func addToLibrary(book: Book) async {
        isLoading = true
        
        do {
            let newEntry = try await bookRepository.addBookToLibrary(book, status: .wantToRead)
            message = "Dodano do biblioteki!"
            userBookEntry = newEntry
            currentStatus = .wantToRead
            
        } catch {
            message = " Błąd: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func checkIfAlreadyInLibrary(book: Book) async {
        
        do {
            userBookEntry = try await bookRepository.isBookInLibrary(book.id)
            currentStatus = ReadingStatus(rawValue: userBookEntry?.status ?? "") ?? .wantToRead
            
        } catch {
            message = " Błąd: \(error.localizedDescription)"
        }
        
    }
    
    func getStatusEmoji(_ status: ReadingStatus) -> String {
        switch status {
        case .wantToRead: return "📚"
        case .currentlyReading: return "📖"
        case .finished: return "✅"
        case .pause: return "⏸️"
        }
    }
    
}
