//
//  BookDetailsSheetContentView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 09/06/2025.
//

import SwiftUI
import BookAPiKit


struct BookDetailsSheetContentView: View {
    let book: Book
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: BookDetailsViewModel
    
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                bookImageSection
                statusSection
                messageSection
                bookInfoSection
            }
        }
        .navigationTitle("Szczegóły książki")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                dismissButton
            }
        }
    }
    

}

private extension BookDetailsSheetContentView{
    
    var bookImageSection: some View {
        BookImageView(book: book)
            .frame(height: 300)
    }
    
    @ViewBuilder
    var statusSection: some View {
        if viewModel.userBookEntry != nil {
            statusMenu
        } else {
            addToLibraryButton
        }
    }
    
    var statusMenu: some View {
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
    
    var addToLibraryButton: some View {
        Button(viewModel.isLoading ? "Dodawanie..." : "Dodaj do Want to Read") {
            Task {
                await viewModel.addToLibrary(book: book)
            }
        }
        .disabled(viewModel.isLoading)
        .buttonStyle(.borderedProminent)
        .padding()
    }
    
    @ViewBuilder
    var messageSection: some View {
        if let message = viewModel.message {
            Text(message)
                .foregroundColor(message.contains("Błąd") ? .red : .green)
                .padding(.horizontal)
                .animation(.easeInOut, value: message)
        }
    }
    
    var bookInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            bookTitle
            authorsSection
            publishedDateSection
            descriptionSection
        }
        .padding()
    }
    
    var bookTitle: some View {
        Text(book.title)
            .font(.title)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
    
    var authorsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Autorzy:")
                .font(.headline)
            Text(book.authors.joined(separator: ", "))
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    var publishedDateSection: some View {
        if let publishedDate = book.publishedDate {
            VStack(alignment: .leading, spacing: 4) {
                Text("Data publikacji:")
                    .font(.headline)
                Text(publishedDate)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Opis:")
                .font(.headline)
                .padding(.top)
            
            if let description = book.description, !description.isEmpty {
                Text(description)
                    .font(.body)
            } else {
                Text("Brak opisu")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
    }
    
    var dismissButton: some View {
        Button("Zamknij") {
            dismiss()
        }
    }
    
}
