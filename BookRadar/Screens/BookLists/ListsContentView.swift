//
//  ListsContentView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 12/06/2025.
//

import SwiftUI

struct ListsContentView: View {
    
    @Bindable var viewModel: ListsViewModel
    
    
    var body: some View {
        
        VStack{
            
            if viewModel.isLoading {
                ProgressView("Wczytywanie książek...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else{
                List{
                    ForEach(ReadingStatus.allCases, id: \.self) { status in
                        
                        
                        StatusRowView(status: status, count: viewModel.getBooksCount(for: status), books: viewModel.getBooks(for: status))
                        
                        
                    }
                }
                .listStyle(.plain)
                .navigationDestination(for: ReadingStatus.self) { status in
                    BooksView(status: status, title: status.displayName)
                        .onDisappear{
                            Task{
                                await viewModel.refresh()
                            }
                        }
                }
            }
        }
    }
}


