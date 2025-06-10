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
            
            Text("Moje książki")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding()
            
            Group {
                if let viewModel = viewModel {
                    MyBooksContentView(viewModel: viewModel)
                } else {
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
