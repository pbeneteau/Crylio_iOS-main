//
//  MarketSubMenuCollectionViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 07/06/2021.
//

import UIKit

class MarketSubMenuCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "MarketSubMenuCollectionViewCell"
    
    lazy var view = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(index: Int) {
        
        switch index {
        case 0:
            view = FavoriteFilterButtonView()
        case 1:
            view = SortByButtonView()
        case 2:
            view = CurrencyButtonView()
        case 3:
            view = ChangeTimelineButton()
        default:
            return
        }
        
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().priority(999)
            make.height.equalTo(35)
        }
        
    }
    
    override func layoutIfNeeded() {
        
        view.snp.remakeConstraints { make in
            make.top.left.right.equalToSuperview().priority(999)
            make.height.equalTo(35)
        }
        
    }
    
}


