//
//  MarketSubMenu.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 04/06/2021.
//

import UIKit

class MarketSubMenu: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    private func configure() {
        
        backgroundColor = .clear
        
        translatesAutoresizingMaskIntoConstraints = false
        contentInsetAdjustmentBehavior = .never
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        register(MarketSubMenuCollectionViewCell.self, forCellWithReuseIdentifier: MarketSubMenuCollectionViewCell.reuseId)
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 150, height: 35)
            flowLayout.scrollDirection = .horizontal
        }
        
        delegate = self
        dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarketSubMenuCollectionViewCell.reuseId, for: indexPath) as! MarketSubMenuCollectionViewCell
        
        cell.configure(index: indexPath.row)

        return cell
    }

}
