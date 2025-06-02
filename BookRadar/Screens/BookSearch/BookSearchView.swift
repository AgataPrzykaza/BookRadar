//
//  BookSearchView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 02/06/2025.
//

import SwiftUI


struct BookSearchView: View {
    
    @State private var viewModel = BookSearchViewModel()
 

    
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
                List(viewModel.books, id: \.id) { book in
                    VStack(alignment: .leading) {
                        Text(book.title)
                            .font(.headline)
                        Text(book.authors.joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
    }
}

#Preview {
    BookSearchView()
}
