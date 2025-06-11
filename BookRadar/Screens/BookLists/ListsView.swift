//
//  Listsview.swift
//  BookRadar
//
//  Created by Agata Przykaza on 11/06/2025.
//

import SwiftUI





struct ListsView: View {
    
    private var bookRepository = BookRepository()
    @State var booksByStatus: [ReadingStatus: [UserBookEntry]] = [:]
    @State var booksCountByStatus: [ReadingStatus: Int] = [:]
    
    @State var isLoading = false
    
    func loadPreviews() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            for status in ReadingStatus.allCases {
                let books = try await bookRepository.fetchBooks(with: status, limit: 3)
                booksByStatus[status] = books
            }
        } catch {
            print("Błąd: \(error.localizedDescription)")
        }
    }
    
    func getBooks(for status: ReadingStatus) -> [UserBookEntry] {
        return booksByStatus[status] ?? []
    }
    
    func getBooksCount(for status: ReadingStatus) -> Int{
        return booksCountByStatus[status] ?? 0
    }
    
    func getBooksCount() async {
        
        do{
            for status in ReadingStatus.allCases {
                let booksCount = try await bookRepository.getBooksCount(for: status)
                booksCountByStatus[status] = booksCount
                
            }
        } catch {
            print("Błąd: \(error.localizedDescription)")
        }
        
    }
    
    
    var body: some View {
        List{
            ForEach(ReadingStatus.allCases, id: \.self) { status in
                
                StatusRowView(status: status, count: getBooksCount(for: status), books: getBooks(for: status))
                
            }
        }
        .task {
            await loadPreviews()
            await getBooksCount()
        }
    }
}

struct StatusRowView: View{
    
    let status: ReadingStatus
    let count: Int
    let books: [UserBookEntry]
    
    var body: some View{
        HStack(spacing: 10) {
            
            HStack(spacing: 8) {
                ForEach(books.prefix(3)) { book in
                    UserBookImageView(userBook: book)
                        .frame(height: 70)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
           
            VStack(alignment: .leading, spacing: 4) {
                Text(status.displayName)
                    .fontWeight(.medium)
                Text("\(count) książek")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(minWidth: 120, alignment: .trailing)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ListsView()
}
