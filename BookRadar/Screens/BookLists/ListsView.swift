//
//  Listsview.swift
//  BookRadar
//
//  Created by Agata Przykaza on 11/06/2025.
//

import SwiftUI

struct ListsView: View {
    
    @Environment(\.bookRepository) private var repository
    @State private var viewModel: ListsViewModel?
    
    var body: some View {
        
        NavigationStack{
            
            Group{
                if let viewModel = viewModel{
                    ListsContentView(viewModel: viewModel)
                } else {
                    ProgressView("Wczytywnie...")
                }
            }
            
            
        }
        .task{
            if viewModel == nil {
                viewModel = ListsViewModel(bookRepository: repository)
                
                await viewModel?.loadPreviews()
                await viewModel?.getBooksCount()
            }
        }
        
       
    }
}





#Preview {
    ListsView()
}
