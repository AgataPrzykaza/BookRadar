//
//  BooksViewModel.swift
//  BookRadar
//
//  Created by Agata Przykaza on 12/06/2025.
//

import Foundation

@MainActor
@Observable
class BooksViewModel {
    
    private var bookRepository: BookRepositoryProtocol
    private let status: ReadingStatus?
    
    var books: [UserBookEntry] = []
    var isLoading = false
    var errorMessage: String?
    
    init(bookRepository: BookRepositoryProtocol, status: ReadingStatus? = nil) {
        self.bookRepository = bookRepository
        self.status = status
    }
    
    func loadBooks() async {
        isLoading = true
        errorMessage = nil
        
        do {
            if let status = status {
                books = try await bookRepository.fetchBooks(with: status)
            } else {
                books = try await bookRepository.fetchMyBooks()
            }
        } catch {
            errorMessage = "Failed to load books: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func refreshBooks() async {
        await loadBooks()
    }
}

