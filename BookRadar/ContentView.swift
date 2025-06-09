//
//  ContentView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 30/05/2025.
//

import SwiftUI
import BookAPiKit
import UIKit

struct SimpleRepositoryTest: View {
    @State private var repository = BookRepository()
    @State private var testResult = "Nie testowano jeszcze"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Repository Test")
                .font(.title)
            
            Text(testResult)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Button("Pobierz książki z bazy") {
                Task {
                    await fetchBooks()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func fetchBooks() async {
        do {
            // Pobierz wszystkie książki z bazy
            let allBooks = try await repository.fetchMyBooks()
            
            if allBooks.isEmpty {
                testResult = """
                📚 BAZA PUSTA
                Brak książek w bibliotece.
                Dodaj jakieś książki przez wyszukiwanie!
                """
            } else {
                // Pokaż szczegóły każdej książki
                var result = "📚 KSIĄŻKI W BAZIE (\(allBooks.count)):\n\n"
                
                for (index, book) in allBooks.enumerated() {
                    result += """
                    \(index + 1). \(book.book?.title ?? "Brak tytułu")
                       Autor: \(book.book?.authors ?? "Nieznany")
                       Status: \(book.status)
                       Rating: \(book.rating)/5
                       Ulubiona: \(book.isFavorite ? "❤️" : "🤍")
                       Dodana: \(book.dateAdded.formatted(date: .abbreviated, time: .omitted))
                    
                    """
                }
                
                testResult = result
            }
            
        } catch {
            testResult = "❌ ERROR: \(error.localizedDescription)"
        }
    }
}

struct ContentView: View {
    
    @State private var viewModel = BookSearchViewModel()
    @State private var selectedBook: Book?
    
    var body: some View {
        @Bindable var bindableViewModel = viewModel
        
        VStack {
            
            HStack {
                TextField("Wyszukaj książki..", text: $bindableViewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Szukaj") {
                    if viewModel.validateInput() == true {
                        Task {
                            await viewModel.search(query: bindableViewModel.searchText)
                        }
                    }
                    
                }
                .disabled(viewModel.isLoading)
            }
            .padding()
            
            if viewModel.isLoading {
                ProgressView("Wyszukiwanie...")
                
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                
            } else {
                BookCollectionView(books: viewModel.books) { book in
                    
                    selectedBook = book
                    
                }
                
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .sheet(item: $selectedBook) { book in
            BookDetailsSheet(book: book)
        }
    }
}

#Preview {
    ContentView()
}
