//
//  SwiftUIUserBookCell.swift
//  BookRadar
//
//  Created by Agata Przykaza on 05/06/2025.
//

import UIKit
import SwiftUI

class SwiftUIUserBookCell: UICollectionViewCell {
    
    private var hostingController: UIHostingController<UserBookImageView>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .clear
        layer.cornerRadius = 8
    }
    
    func configure(with book: UserBookEntry) {
      
        hostingController?.view.removeFromSuperview()
        hostingController?.removeFromParent()
      
        let swiftUIView = UserBookImageView(userBook: book)
        let hostingController = UIHostingController(rootView: swiftUIView)
       
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        self.hostingController = hostingController
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hostingController?.view.removeFromSuperview()
        hostingController = nil
    }
}
