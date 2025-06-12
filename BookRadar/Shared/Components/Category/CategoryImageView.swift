//
//  CategoryImageView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 12/06/2025.
//

import SwiftUI

struct CategoryImageView: View {
    
    
    let books: [UserBookEntry]
    
    var body: some View {
        HStack(spacing: 8) {
            
            Group {
                if let firstBook = books.first {
                    UserBookImageView(userBook: firstBook)
                        .frame(height: 100)
                } else {
                    placeholderView(width: 60, height: 100)
                }
            }
            
            
            VStack(spacing: 4) {
                Group {
                    if books.count >= 2 {
                        UserBookImageView(userBook: books[1])
                            .frame(height: 46)
                    } else {
                        placeholderView(width: 30, height: 46, showIcon: false)
                    }
                }
                
                Group {
                    if books.count >= 3 {
                        UserBookImageView(userBook: books[2])
                            .frame(height: 46)
                    } else {
                        placeholderView(width: 30, height: 46, showIcon: false)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func placeholderView(width: CGFloat, height: CGFloat, showIcon: Bool = true) -> some View {
        Rectangle()
            .fill(Color.gray.opacity(showIcon ? 0.3 : 0.1))
            .frame(width: width, height: height)
            .cornerRadius(6)
           
    }
    
}
