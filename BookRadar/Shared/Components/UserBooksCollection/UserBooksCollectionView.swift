//
//  UserBooksCollectionView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 05/06/2025.
//

import UIKit
import SwiftUI

struct UserBooksCollectionView: UIViewControllerRepresentable {
    
    let books: [UserBookEntry]
    let onBookTapped: (UserBookEntry) -> Void
    
    func makeUIViewController(context: Context) -> UserBooksCollectionViewController {
        let controller = UserBooksCollectionViewController()
        controller.onBookTapped = onBookTapped
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UserBooksCollectionViewController, context: Context) {
        uiViewController.books = books
        uiViewController.collectionView.reloadData()
    }
}
