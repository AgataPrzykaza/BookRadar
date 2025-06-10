//
//  Untitled.swift
//  BookRadar
//
//  Created by Agata Przykaza on 02/06/2025.
//

import SwiftUI
import BookAPiKit

struct BookDetailsSheet: View {
   
    @Environment(\.bookRepository) private var repository
    let book: Book
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: BookDetailsViewModel?
    
    var body: some View {
        NavigationStack {
            Group {
                if let viewModel = viewModel {
                    BookDetailsSheetContentView(book: book, viewModel: viewModel)
                } else {
                    ProgressView("Wczytywanie książki...")
                }
            }
        }
        .task {
            if viewModel == nil {
                viewModel = BookDetailsViewModel(bookRepository: repository)
                await viewModel?.checkIfAlreadyInLibrary(book: book)
            }
        }    }
    
}
