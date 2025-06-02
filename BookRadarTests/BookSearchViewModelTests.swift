//
//  BookSearchViewModelTests.swift
//  BookRadarTests
//
//  Created by Agata Przykaza on 02/06/2025.
//

import Testing
import BookAPiKit
import Foundation
@testable import BookRadar

class MockBookAPIService: BookAPIServiceProtocol {
    var mockBooks: [Book] = []
    var shouldReturnError = false
    var delay: TimeInterval = 0
    
    func searchBooks(query: String, type: BookSearchType, maxResult: Int) async throws -> [Book] {
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        if shouldReturnError {
            throw BookAPIError.invalidResponse
        }
        
        return mockBooks
    }
}

@Suite("BookSearchViewModelTests")
@MainActor
struct BookSearchViewModelTests {
    
    func createViewModel() -> (BookSearchViewModel,MockBookAPIService){
        
        let mockAPI = MockBookAPIService()
        let viewModel = BookSearchViewModel(bookAPIService: mockAPI)
        return (viewModel,mockAPI)
    }

    @Test("validateInput returns false for empty text")
    func validateInputReturnsFalseForEmptyText() {
        // Given
        let (viewModel, _) = createViewModel()
        viewModel.searchText = ""
        
        // When
        let isValid = viewModel.validateInput()
        
        // Then
        #expect(isValid == false)
        #expect(viewModel.errorMessage == "Wprowadź przynajmniej 3 znaki.")
    }
    
    @Test("validateInput returns true when text has 3 characters")
      func validateInputReturnsTrueForThreeCharacters() {
          // Given
          let (viewModel, _) = createViewModel()
          viewModel.searchText = "abc"
          
          // When
          let isValid = viewModel.validateInput()
          
          // Then
          #expect(isValid == true)
          #expect(viewModel.errorMessage == nil)
      }
    
    @Test("validateInput return true when text has longer than 3 characters")
        func validateInputReturnsTrueForLongerText() {
            // Given
            let (viewModel, _) = createViewModel()
            viewModel.searchText = "Swift Programming"
            
            // When
            let isValid = viewModel.validateInput()
            
            // Then
            #expect(isValid == true)
            #expect(viewModel.errorMessage == nil)
        }
    
    @Test("Whole workflow")
        func completeWorkflowValidationSearchSuccess() async {
            // Given
            let (viewModel, mockAPI) = createViewModel()
            let expectedBooks = [Book(id: "1", title: "Swift", authors: ["Apple"])]
            mockAPI.mockBooks = expectedBooks
            
            viewModel.searchText = "Swift"
            
            // When
            let isValid = viewModel.validateInput()
            
            // Then
            #expect(isValid == true)
            #expect(viewModel.errorMessage == nil)
            
            // When
            await viewModel.search(query: viewModel.searchText)
            
            // Then
            #expect(viewModel.books.count == 1)
            #expect(viewModel.books[0].title == "Swift")
            #expect(viewModel.isLoading == false)
            #expect(viewModel.errorMessage == nil)
        }

}
