//
//  BookSearchView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 02/06/2025.
//

import SwiftUI
import BookAPiKit


struct BookSearchView: View {
    
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
    BookSearchView()
}
