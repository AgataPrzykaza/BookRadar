//
//  Untitled.swift
//  BookRadar
//
//  Created by Agata Przykaza on 02/06/2025.
//
import UIKit
import SwiftUI
import BookAPiKit

class BookCollectionViewController: UIViewController {
    
    var books: [Book] = []
    var collectionView: UICollectionView!
    var onBookTapped: ((Book) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SwiftUIImageBookCell.self, forCellWithReuseIdentifier: "BookCell")
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
              NSLayoutConstraint.activate([
                  collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                  collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                  collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                  collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
              ])
    }
    
}

extension BookCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! SwiftUIImageBookCell
        let book = books[indexPath.item]
        cell.configure(with: book)
        return cell
    }
}

extension BookCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = books[indexPath.item]
       
        onBookTapped?(book)
    }
    
}
