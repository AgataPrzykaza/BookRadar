//
//  MyBooksView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 05/06/2025.
//

import SwiftUI



struct MyBooksView: View {
    
    @Environment(\.bookRepository) private var repository
    @State private var viewModel: MyBooksViewModel?
    
    var body: some View {
        
        NavigationStack {
            Group{
                if let viewModel = viewModel {
                    MyBooksContentView(viewModel: viewModel)
                } else{
                    ProgressView("Wczytywanie książek...")
                }
            }
        }
        .task {
            if viewModel == nil {
                viewModel = MyBooksViewModel(bookRepository: repository)
                await viewModel?.loadBooks()
            }
        }    }
}


#Preview {
    MyBooksView()
     
}
