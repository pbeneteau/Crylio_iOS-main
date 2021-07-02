//
//  TransactionsHeaderViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 05/04/2021.
//

import UIKit

class TransactionsHeaderView: UITableViewHeaderFooterView {
    
    static let reuseId = "TransactionsHeaderView"
    lazy var date = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView?.backgroundColor = .clear
        tintColor = .clear
        
        date.font = .systemFont(ofSize: 20, weight: .bold)
        
        addSubview(date)
        
        date.snp.makeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.top.equalTo(0)
            make.height.equalTo(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func configure(with dateString: String) {
        
        date.text = dateString
    }
    
}
