//
//  Untitled.swift
//  BookRadar
//
//  Created by Agata Przykaza on 02/06/2025.
//

import SwiftUI
import BookAPiKit

@MainActor
@Observable
class BookDetailsViewModel {
    
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
    
     func addToLibrary(book: Book) async {
        isLoading = true
        
        do {
            let newEntry = try await bookRepository.addBookToLibrary(book, status: .wantToRead)
            message = "Dodano do biblioteki!"
            userBookEntry = newEntry
            currentStatus = .wantToRead
            
        } catch {
            message = " Błąd: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    
    func checkIfAlreadyInLibrary(book: Book) async  {
        
        
        do{
            userBookEntry = try await bookRepository.isBookInLibrary(book.id)
            currentStatus = ReadingStatus(rawValue: userBookEntry?.status ?? "") ?? .wantToRead
            
           
        }
        catch{
           message = " Błąd: \(error.localizedDescription)"
        }
        
        
    }
    
     func getStatusEmoji(_ status: ReadingStatus) -> String {
        switch status {
        case .wantToRead: return "📚"
        case .currentlyReading: return "📖"
        case .finished: return "✅"
        case .pause: return "⏸️"
        }
    }

}



struct BookDetailsSheet: View {
   
    @Environment(\.bookRepository) private var repository
    let book: Book
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: BookDetailsViewModel?
    
    var body: some View{
        NavigationStack {
            Group{
                if let viewModel = viewModel {
                    BookDetailsSheetContentView(book: book, viewModel: viewModel)
                } else{
                    ProgressView("Wczytywanie książek...")
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


struct BookDetailsSheetContentView: View {
    let book: Book
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: BookDetailsViewModel
    
  
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                
               
                
                BookImageView(book: book)
                    .frame(height: 300)
                
                if viewModel.userBookEntry != nil {
                   
                    Menu {
                        ForEach(ReadingStatus.allCases, id: \.self) { status in
                            Button {
                                viewModel.currentStatus = status
                            } label: {
                               
                                Text("\(viewModel.getStatusEmoji(status)) \(status.displayName)")
                                
                            }
                        }
                    } label: {
                        HStack(spacing: 8) {
                            StatusBadge(status: viewModel.currentStatus)
                            
                            Image(systemName: "chevron.down")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                else {
                    Button(viewModel.isLoading ? "Dodawanie..." : "Dodaj do Want to Read") {
                        Task {
                            await viewModel.addToLibrary(book: book)
                        }
                    }
                    .disabled(viewModel.isLoading)
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                
                if let message = viewModel.message {
                                    Text(message)
                                        .foregroundColor(message.contains("Błąd") ? .red : .green)
                                        .padding(.horizontal)
                                        .animation(.easeInOut, value: message)
                                }
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    
                    Text(book.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    
                    Text("Autorzy:")
                        .font(.headline)
                    Text(book.authors.joined(separator: ", "))
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    
                    if let publishedDate = book.publishedDate {
                        Text("Data publikacji:")
                            .font(.headline)
                        Text(publishedDate)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    
                    if let description = book.description, !description.isEmpty {
                        Text("Opis:")
                            .font(.headline)
                            .padding(.top)
                        
                        Text(description)
                            .font(.body)
                    } else {
                        Text("Brak opisu")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
                .padding()
                
                
            }
            
            
        }
        .navigationTitle("Szczegóły książki")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Zamknij") {
                    dismiss()
                }
            }
        }
        
        
    }
    
}
