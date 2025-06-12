//
//  TabView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 05/06/2025.
//

import SwiftUI

struct TabsView: View {
    
    var body: some View {
       TabView {
           Tab {
               NavigationStack{
                   BooksView()
               }
           } label: {
               Image(systemName: "book.fill")
           }
           
           Tab {
               BookSearchView()
           } label: {
               Image(systemName: "magnifyingglass")
           }
           
           Tab {
               ListsView()
           } label: {
               Image(systemName: "house")
           }


        }
    }
}

#Preview {
    TabsView()
}
