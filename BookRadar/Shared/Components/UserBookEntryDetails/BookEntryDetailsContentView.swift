//
//  BookEntryDetailsContentView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 12/06/2025.
//

import SwiftUI


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
                        
                }
            }
        }
    }
}

