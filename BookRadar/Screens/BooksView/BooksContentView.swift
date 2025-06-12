//
//  BooksContentView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 12/06/2025.
//
import SwiftUI

struct BooksContentView: View {
    @Bindable var viewModel: BooksViewModel
    
    @State private var selectedBook: UserBookEntry?
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Wczytywanie książek...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else if viewModel.books.isEmpty {
                Text("Brak książek")
                
            } else {
                UserBooksCollectionView(books: viewModel.books) { book in
                    selectedBook = book
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationDestination(item: $selectedBook) { book in
            BookEntryDetailsView(bookEntry: book)
                .onDisappear{
                    Task {
                        await viewModel.refreshBooks()
                    }
                   
                }
        }
    }
}

