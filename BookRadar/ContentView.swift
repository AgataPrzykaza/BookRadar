//
//  ContentView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 30/05/2025.
//

import SwiftUI
import BookAPiKit

struct ContentView: View {
    let service = BookAPIService()
    @State var books: [Book] = []
    
    var body: some View {
        ScrollView{
            VStack {
                ForEach(books){ book in
                    Text(book.title)
                    Text(book.authors.joined(separator: ","))
                    Divider()
                    
                    
                }
            }
            .padding()
            .task{
                do{
                    books = try await service.searchBooks(query: "Penn Cole",type: .author)
                }
                catch{
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
