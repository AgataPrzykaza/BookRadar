//
//  StatusRowView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 12/06/2025.
//
import SwiftUI

struct StatusRowView: View{
    
    let status: ReadingStatus
    let count: Int
    let books: [UserBookEntry]
    
    
    
    var body: some View{
        NavigationLink(value: status) {
            HStack(spacing: 10) {
                
                
               CategoryImageView(books: books)
                
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(status.displayName)
                        .fontWeight(.medium)
                    Text(bookCountText(for: count))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(width: 200,alignment: .leading)
                
             
                
            }
           
            
        }
        }
       
}
