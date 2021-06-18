//
//  TransactionsHeaderViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 05/04/2021.
//

import UIKit

class TransactionsHeaderView: UITableViewHeaderFooterView {
    
    static let reuseId = "HeaderView"

    lazy var date = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundView?.backgroundColor = .clear
        backgroundView?.layer.masksToBounds = false
        layer.masksToBounds = false
        tintColor = .clear
        
        date.font = .systemFont(ofSize: 20, weight: .bold)
                
        addSubview(date)
        
        date.snp.makeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.height.equalTo(24)
        }
    }
    
}
