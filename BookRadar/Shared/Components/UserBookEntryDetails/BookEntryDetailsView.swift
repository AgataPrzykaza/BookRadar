//
//  BookEntryDeatilsView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 10/06/2025.
//

import SwiftUI

    
struct BookEntryDetailsView: View {
    
    @Environment(\.bookRepository) private var repository
    @State private var viewModel: BookEntryDetailsViewModel?
    var bookEntry: UserBookEntry
    
    var body: some View {
        Group {
            if let viewModel = viewModel {
                BookEntryDetailsContentView(userBookEntry: bookEntry, viewModel: viewModel)
            } else {
                ProgressView("Wczytywanie książki...")
            }
        }
        .task {
            if viewModel == nil {
                viewModel = BookEntryDetailsViewModel(bookRepository: repository,userBookEntry: bookEntry)
                viewModel?.loadCurrentStatus()
            }
        }
    }
}


// #Preview {
//    BookEntryDeatilsView()
// }
