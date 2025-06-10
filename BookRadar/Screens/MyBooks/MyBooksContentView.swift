//
//  MyBookContentView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 06/06/2025.
//

import SwiftUI

struct MyBooksContentView: View {
    
    @Bindable var viewModel: MyBooksViewModel
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
               
               
            }
            
            if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
        }
        .navigationDestination(item: $selectedBook) { book in
            BookEntryDeatilsView(bookEntry: book)
               
        }
       
    }
}

// #Preview {
//    MyBooksContentView()
// }
