//
//  BookEntryDetailsViewModel.swift
//  BookRadar
//
//  Created by Agata Przykaza on 12/06/2025.
//

import Foundation


@MainActor
@Observable
class BookEntryDetailsViewModel {
    
    private var bookRepository: BookRepositoryProtocol
    
    var isLoading = false
    var message: String?
    var userBookEntry: UserBookEntry
    var currentStatus: ReadingStatus? {
        didSet {
            
            if let newStatus = currentStatus, newStatus != oldValue {
                Task {
                    await updateStatus(newStatus)
                }
            }
        }
    }
    
    init(bookRepository: BookRepositoryProtocol, userBookEntry: UserBookEntry) {
        self.bookRepository = bookRepository
        self.userBookEntry = userBookEntry
    }
    
    func loadCurrentStatus()  {
        currentStatus = ReadingStatus(rawValue: userBookEntry.status)
        
    }
    
    func updateStatus(_ newStatus: ReadingStatus) async {
        
        
        userBookEntry.status = newStatus.rawValue
        currentStatus = newStatus
        
        do {
            
            try await bookRepository.updateBookStatus(userBookEntry, status: newStatus)
            
            message = "Status zaktualizowany! dla \(newStatus.displayName)"
        } catch {
            message = "Błąd: \(error.localizedDescription)"
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
