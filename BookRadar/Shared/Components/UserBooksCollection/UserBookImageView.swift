//
//  UserBookImageView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 05/06/2025.
//

import SwiftUI

struct UserBookImageView: View {
    
    var userBook: UserBookEntry
    
    var body: some View {
        
        if let thumbnailURLString = userBook.book?.thumbnailURL,
           !thumbnailURLString.isEmpty,
           let url = URL(string: thumbnailURLString) {
            
            // Ma prawidłowy URL - pokaż AsyncImage
            AsyncImage(url: url.httpsURL) { image in
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
            
        } else {
            
            // Brak URL lub pusty string - pokaż placeholder
            Image(systemName: "book.closed")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
                .frame(maxHeight: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

// #Preview {
//    UserBookImageView()
// }
