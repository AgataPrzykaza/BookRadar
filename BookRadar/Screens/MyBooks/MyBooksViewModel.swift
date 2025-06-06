//
//  MyBooksViewModel.swift
//  BookRadar
//
//  Created by Agata Przykaza on 06/06/2025.
//
import Foundation

@MainActor
@Observable
class MyBooksViewModel{
    
    private var bookRepository: BookRepositoryProtocol
    
    var books: [UserBookEntry] = []
    var isLoading = false
    var errorMessage: String?
    
    init(bookRepository: BookRepositoryProtocol) {
        self.bookRepository = bookRepository
    }
    
    func loadBooks() async{
        isLoading = true
        errorMessage = nil
        
        do {
            books = try await bookRepository.fetchMyBooks()
        } catch {
            errorMessage = "Failed to load books: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

