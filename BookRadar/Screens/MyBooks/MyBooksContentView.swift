//
//  MyBookContentView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 06/06/2025.
//

import SwiftUI

struct MyBooksContentView: View {
    
    @Bindable var viewModel: MyBooksViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Wczytywanie książek...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else if viewModel.books.isEmpty {
                
                Text("Brak książek")
                
            } else {

                UserBooksCollectionView(books: viewModel.books) { _ in
                    
                }
            }
            
            if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
        }
    }
}

// #Preview {
//    MyBooksContentView()
// }
