//
//  Untitled.swift
//  BookRadar
//
//  Created by Agata Przykaza on 02/06/2025.
//

import SwiftUI
import BookAPiKit

struct BookDetailsSheet: View {
    let book: Book
    @Environment(\.dismiss) private var dismiss
    
    @State private var repository = BookRepository()
    @State private var isLoading = false
    @State private var message: String?
    
    private func addToLibrary() async {
        isLoading = true
        
        do {
            let _ = try await repository.addBookToLibrary(book, status: .wantToRead)
            message = "✅ Dodano do biblioteki!"
        } catch {
            message = "❌ Błąd: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    
                    BookImageView(book: book)
                        .frame(height: 300)
                    
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
                    
                    if isLoading {
                        ProgressView("Dodawanie...")
                    } else {
                        Button("Dodaj do Want to Read") {
                            Task {
                                await addToLibrary()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
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
}
