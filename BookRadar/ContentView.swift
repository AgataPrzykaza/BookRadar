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
            
            Button("Test Repository") {
                Task {
                    await testRepository()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func testRepository() async {
        do {
            // Stwórz fake API book
            let fakeAPIBook = Book(
                id: "test-api-book",
                title: "Swift Programming Guide",
                authors: ["Apple Inc."],
                publishedDate: "2024",
                description: "Great book about Swift",
                thumbnailURL: nil
            )
            
            // Test repository method
            let userEntry = try await repository.addBookToLibrary(fakeAPIBook, status: .wantToRead)
            
            // Pobierz z bazy
            let allBooks = try await repository.fetchMyBooks()
            
            testResult = """
            ✅ SUCCESS!
            Dodano książkę: \(userEntry.book?.title ?? "brak")
            Status: \(userEntry.status)
            Wszystkich książek w bibliotece: \(allBooks.count)
            """
            
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
        
        VStack{
            
            HStack{
                TextField("Wyszukaj książki..",text: $bindableViewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Szukaj"){
                    if viewModel.validateInput() == true{
                        Task{
                            await viewModel.search(query: bindableViewModel.searchText)
                        }
                    }
                    
                }
                .disabled(viewModel.isLoading)
            }
            .padding()
            
            
            if viewModel.isLoading {
                ProgressView("Wyszukiwanie...")
                
            }
            else if let errorMessage = viewModel.errorMessage{
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                
            }
            else{
                BookCollectionView(books: viewModel.books){ book in
                    
                    selectedBook = book
                   
                    
                }
                
                
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
        .sheet(item: $selectedBook) { book in
            BookDetailsSheet(book: book)
        }
    }
}

#Preview {
    ContentView()
}
