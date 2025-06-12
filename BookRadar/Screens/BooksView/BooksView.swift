//
//  BooksView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 12/06/2025.
//

import SwiftUI
struct BooksView: View {
    
    @Environment(\.bookRepository) private var repository
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: BooksViewModel?
    
    let status: ReadingStatus?
    let title: String
    let showBackButton: Bool
    
   
    init(title: String = "Moje książki", showBackButton: Bool = false) {
        self.status = nil
        self.title = title
        self.showBackButton = showBackButton
    }
    
   
    init(status: ReadingStatus, title: String, showBackButton: Bool = true) {
        self.status = status
        self.title = title
        self.showBackButton = showBackButton
    }
    
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Group {
                if let viewModel = viewModel {
                    BooksContentView(viewModel: viewModel)
                } else {
                    ProgressView("Wczytywanie książek...")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            if showBackButton {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            
                    }
                }
            }
        }
        .task {
            if viewModel == nil {
                viewModel = BooksViewModel(bookRepository: repository, status: status)
                await viewModel?.loadBooks()
            }
        }
        
    }
}
