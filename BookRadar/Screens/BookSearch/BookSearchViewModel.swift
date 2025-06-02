//
//  BookSearchViewModel.swift
//  BookRadar
//
//  Created by Agata Przykaza on 02/06/2025.
//

import SwiftUI
import BookAPiKit

@MainActor
@Observable class BookSearchViewModel {
   
    var errorMessage: String?
    var isLoading: Bool = false
    var searchText: String = ""
    
    var books: [Book] = []
    
    private let bookAPIService: BookAPIServiceProtocol
       
       init(bookAPIService: BookAPIServiceProtocol = BookAPIService()) {
           self.bookAPIService = bookAPIService
       }
    
    func validateInput() -> Bool {
        if searchText.isEmpty || searchText.count < 3 {
            errorMessage = "Wprowadź przynajmniej 3 znaki."
            return false
        }
        
        return true
    }
    
    func search(query: String,type: BookSearchType = .all) async{
        
        
        errorMessage = nil
        isLoading = true
        
        do{
            let searchResults = try await bookAPIService.searchBooks(
                query: query,
                type: type,
                maxResult: 20
            )
            books = searchResults
        }
        catch{
            handleError(error)
            
            
        }
        
        isLoading = false
    }
    
    func clearResults() {
        books = []
        errorMessage = nil
    }
    
    private func handleError(_ error: Error) {
        if let apiError = error as? BookAPIError {
            switch apiError {
            case .invalidURL:
                errorMessage = "Nieprawidłowy adres URL."
            case .invalidResponse:
                errorMessage = "Błąd odpowiedzi serwera."
            case .decodingFailed:
                errorMessage = "Nie udało się odczytać odpowiedzi."
            }
        } else {
            errorMessage = error.localizedDescription
        }
    }
}
