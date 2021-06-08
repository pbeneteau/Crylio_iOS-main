//
//  CryptoDetailHeaderView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 01/02/2021.
//

import UIKit


class CryptoHeaderView: UIView {
    
    lazy var nameLabel = UILabel()
    lazy var symbolLabel = UILabel()
    lazy var icon = UIImageView()
    
    lazy var priceLabel = UILabel()
    lazy var changeLabel = UILabel()
            
    var crypto: Cryptocurrency! {
        didSet {
            initValues()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        symbolLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        priceLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        changeLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        symbolLabel.textColor = AppColors.label.secondary
        
        priceLabel.textAlignment = .right
        changeLabel.textAlignment = .right
                
        addSubview(nameLabel)
        addSubview(symbolLabel)
        addSubview(priceLabel)
        addSubview(changeLabel)
        addSubview(icon)
    }
    
    func initValues() {
        
        nameLabel.text = crypto.name
        symbolLabel.text = crypto.symbol
        priceLabel.setDollarMutableString(value: crypto.price)
        changeLabel.setPercentMutableString(value: crypto.change, colors: true)
        icon.setImage(from: crypto.iconURL)
    }
    
}


// MARK: - Constraints

extension CryptoHeaderView {
    
    override func updateConstraints() {
        
        icon.snp.makeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.top.equalTo(15)
            make.height.width.equalTo(55)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(10)
            make.right.equalTo(snp.centerX).inset(8)
            make.top.equalTo(icon)
            make.height.equalTo(29)
        }
        
        symbolLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(10)
            make.right.equalTo(snp.centerX).inset(8)
            make.bottom.equalTo(icon)
            make.height.equalTo(21)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.left.equalTo(snp.centerX).offset(8)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(29)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.left.equalTo(snp.centerX).offset(8)
            make.centerY.equalTo(symbolLabel)
            make.height.equalTo(21)
        }
        
        super.updateConstraints()
    }

}
