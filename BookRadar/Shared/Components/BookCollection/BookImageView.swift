//
//  BookImageView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 02/06/2025.
//
import SwiftUI
import BookAPiKit

struct BookImageView: View {
    let book: Book
    
    var body: some View {
      
            AsyncImage(url: book.thumbnailURL?.httpsURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(systemName: "book.closed")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
            }
            .frame(maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
           
       
    }
}
