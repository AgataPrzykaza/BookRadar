//
//  BookCollectionView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 02/06/2025.
//

import UIKit
import SwiftUI
import BookAPiKit

struct BookCollectionView: UIViewControllerRepresentable {
    let books: [Book]
    let onBookTapped: (Book) -> Void
    
    func makeUIViewController(context: Context) ->  BookCollectionViewController {
        let controller = BookCollectionViewController()
        controller.onBookTapped = onBookTapped
        return controller
    }
    
    func updateUIViewController(_ uiViewController: BookCollectionViewController, context: Context) {
        uiViewController.books = books
        uiViewController.collectionView.reloadData()
        
    }
}
