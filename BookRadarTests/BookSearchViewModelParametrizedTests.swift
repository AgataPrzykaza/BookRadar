//
//  Untitled.swift
//  BookRadar
//
//  Created by Agata Przykaza on 02/06/2025.
//

import Testing
import BookAPiKit
import Foundation
@testable import BookRadar

@Suite("BookSearchViewModel Parametrized Tests")
@MainActor
struct BookSearchViewModelParametrizedTests {
    
    @Test("Diffrent invalid search text lengths", arguments: [
        "", "a", "ab"
    ])
    func invalidSearchTextLengths(searchText: String) {
        // Given
        let mockAPI = MockBookAPIService()
        let viewModel = BookSearchViewModel(bookAPIService: mockAPI)
        viewModel.searchText = searchText
        
        // When
        let isValid = viewModel.validateInput()
        
        // Then
        #expect(isValid == false)
        #expect(viewModel.errorMessage == "Wprowadź przynajmniej 3 znaki.")
    }
    
    @Test("Diffrent valid search text lengths", arguments: [
        "abc", "Swift", "iOS Development", "Very long search query"
    ])
    func validSearchTextLengths(searchText: String) {
        // Given
        let mockAPI = MockBookAPIService()
        let viewModel = BookSearchViewModel(bookAPIService: mockAPI)
        viewModel.searchText = searchText
        
        // When
        let isValid = viewModel.validateInput()
        
        // Then
        #expect(isValid == true)
        #expect(viewModel.errorMessage == nil)
    }
    
}
