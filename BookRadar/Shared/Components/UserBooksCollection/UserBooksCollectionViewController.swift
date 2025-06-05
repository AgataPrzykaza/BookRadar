//
//  UserBooksCollectionViewController.swift
//  BookRadar
//
//  Created by Agata Przykaza on 05/06/2025.
//

import UIKit

class UserBooksCollectionViewController: UIViewController {
    var books: [UserBookEntry] = []
    var collectionView: UICollectionView!
    var onBookTapped: ((UserBookEntry) -> Void)?
    
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
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SwiftUIUserBookCell.self, forCellWithReuseIdentifier: "UserBookCell")
        
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


extension UserBooksCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserBookCell", for: indexPath) as! SwiftUIUserBookCell
        let book = books[indexPath.item]
        cell.configure(with: book)
        return cell
    }
}


extension UserBooksCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = books[indexPath.item]
       
        onBookTapped?(book)
    }
    
}
