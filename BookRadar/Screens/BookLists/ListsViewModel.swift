//
//  ListsViewModel.swift
//  BookRadar
//
//  Created by Agata Przykaza on 12/06/2025.
//

import Foundation

@MainActor
@Observable
final class ListsViewModel {
    private var bookRepository: BookRepositoryProtocol
    
    var booksByStatus: [ReadingStatus: [UserBookEntry]] = [:]
    
    var booksCountByStatus: [ReadingStatus: Int] = [:]
    var isLoading = false
    
    
    init(bookRepository: BookRepositoryProtocol) {
        self.bookRepository = bookRepository
    }
    
    func loadPreviews() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            for status in ReadingStatus.allCases {
                let books = try await bookRepository.fetchBooks(with: status, limit: 3)
                booksByStatus[status] = books
            }
        } catch {
            print("Błąd: \(error.localizedDescription)")
        }
    }
    
    func getBooks(for status: ReadingStatus) -> [UserBookEntry] {
        return booksByStatus[status] ?? []
    }
    
    func getBooksCount(for status: ReadingStatus) -> Int{
        return booksCountByStatus[status] ?? 0
    }
    
    func getBooksCount() async {
        
        do{
            for status in ReadingStatus.allCases {
                let booksCount = try await bookRepository.getBooksCount(for: status)
                booksCountByStatus[status] = booksCount
                
            }
        } catch {
            print("Błąd: \(error.localizedDescription)")
        }
        
    }
    
}


