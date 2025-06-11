//
//  BookEntryDeatilsView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 10/06/2025.
//

import SwiftUI

@MainActor
@Observable
class BookEntryDetailsViewModel {
    
    private var bookRepository: BookRepositoryProtocol
    
    var isLoading = false
    var message: String?
    var userBookEntry: UserBookEntry?
    var currentStatus: ReadingStatus? {
        didSet {
            
            if let newStatus = currentStatus, newStatus != oldValue {
                Task {
                    await updateStatus(newStatus)
                }
            }
        }
    }
    
    init(bookRepository: BookRepositoryProtocol) {
        self.bookRepository = bookRepository
    }
    
    func updateStatus(_ newStatus: ReadingStatus) async {
        guard userBookEntry != nil else { return }
        
        userBookEntry?.status = newStatus.rawValue
        currentStatus = newStatus
        
        do {
            
            try await bookRepository.updateBookStatus(userBookEntry!, status: newStatus)
            
            message = "Status zaktualizowany! dla \(newStatus.displayName)"
        } catch {
            message = "Błąd: \(error.localizedDescription)"
        }
    }
}
    
struct BookEntryDeatilsView: View {
    
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
                viewModel = BookEntryDetailsViewModel(bookRepository: repository)
            }
        }
    }
}

struct BookEntryDetailsContentView: View {
    
    @Environment(\.dismiss) private var dismiss
    var userBookEntry: UserBookEntry
    @Bindable var viewModel: BookEntryDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                if let book = userBookEntry.book {
                    
                    UserBookImageView(userBook: userBookEntry)
                        .frame(height: 300)
                    
                    Text(book.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Autorzy:")
                            .font(.headline)
                        Text(book.authors)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                }
                
            }
        }
        .navigationTitle("Szczegóły książki")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

// #Preview {
//    BookEntryDeatilsView()
// }
