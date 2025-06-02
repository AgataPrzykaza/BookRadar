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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Obrazek książki
                    BookImageView(book: book)
                        .frame(height: 300)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        // Tytuł
                        Text(book.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        // Autorzy
                        Text("Autorzy:")
                            .font(.headline)
                        Text(book.authors.joined(separator: ", "))
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        // Data publikacji
                        if let publishedDate = book.publishedDate {
                            Text("Data publikacji:")
                                .font(.headline)
                            Text(publishedDate)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        // Opis
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
}
