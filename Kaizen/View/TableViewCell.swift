//
//  TableViewCell.swift
//  Kaizen
//
//  Created by Filip Igrutinovic on 20.11.24..
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    var collectionView: UICollectionView!
    var events: [SectionEvent] = []
    var favouriteTap: ((String)->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 110)
        layout.minimumLineSpacing = 10
            
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.backgroundColor = UIColor(named: "Background")
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
            
        contentView.addSubview(collectionView)
            
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with events: [SectionEvent]) {
        self.events = events
        collectionView.reloadData()
    }
}

extension TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.configureCell(event: events[indexPath.item])
        cell.favouriteTapped = { [weak self] in
            let id = self?.events[indexPath.item].id
            if let id = id {
                self?.favouriteTap!(id)
            }
        }
        return cell
    }
}


