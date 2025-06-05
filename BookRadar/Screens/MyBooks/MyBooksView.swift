//
//  MyBooksView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 05/06/2025.
//

import SwiftUI

@MainActor
@Observable
class MyBooksViewModel{
    
    private var bookRepository: BookRepositoryProtocol
    
    var books: [UserBookEntry] = []
    var isLoading = false
    var errorMessage: String?
    
    init(bookRepository: BookRepositoryProtocol) {
        self.bookRepository = bookRepository
    }
    
    func loadBooks() async{
        isLoading = true
        errorMessage = nil
        
        do {
            books = try await bookRepository.fetchMyBooks()
        } catch {
            errorMessage = "Failed to load books: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}



struct MyBooksView: View {
    
    @Environment(\.bookRepository) private var repository
    @State private var viewModel: MyBooksViewModel?
    
    var body: some View {
        
        NavigationStack {
            Group{
                if let viewModel = viewModel {
                    MyBooksContentView(viewModel: viewModel)
                } else{
                    ProgressView("Wczytywanie książek...")
                }
            }
        }
        .task {
            if viewModel == nil {
                viewModel = MyBooksViewModel(bookRepository: repository)
                await viewModel?.loadBooks()
            }
        }    }
}

struct MyBooksContentView: View {
    
    @Bindable var viewModel: MyBooksViewModel
    
    var body: some View {
        VStack{
            if viewModel.isLoading {
                ProgressView("Wczytywanie książek...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else if viewModel.books.isEmpty {
                
                Text("Brak książek")
                
            } else {

                UserBooksCollectionView(books: viewModel.books) { userBook in
                    
                }
            }
            
            if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
        }
    }
}

#Preview {
    MyBooksView()
     
}
