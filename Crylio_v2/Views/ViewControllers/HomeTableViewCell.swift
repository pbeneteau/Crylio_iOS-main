//
//  HomeTableViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 27/01/2021.
//

import UIKit
import SnapKit
import Kingfisher

class HomeTableViewCell: BaseTableViewCell {
    
    static let reuseId = "HomeTableViewCell"

    lazy var backgroundBox = RoundShadowView()
    
    lazy var iconImageView = UIImageView()
    
    lazy var symbolLabel = UILabel()
    lazy var nameLabel = UILabel()
    
    lazy var priceLabel = UILabel()
    lazy var changeLabel = UILabel()
    
    lazy var balanceLabel = UILabel()
    lazy var amountLabel = UILabel()
    
    var crypto: Cryptocurrency? {
        didSet {
            initValues()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        backgroundBox.backgroundColor = AppColors.background.secondary
        
        backgroundBox.layer.cornerRadius = 10
                
        nameLabel.textColor = .systemGray2
        nameLabel.font = nameLabel.font.withSize(15)
        
        balanceLabel.textAlignment = .right
        
        amountLabel.textColor = AppColors.label.secondary
        amountLabel.textAlignment = .right
        amountLabel.font = amountLabel.font.withSize(15)
        
        priceLabel.textAlignment = .right
        
        changeLabel.textAlignment = .right
        changeLabel.font = amountLabel.font
        
        contentView.addSubview(backgroundBox)
        backgroundBox.addSubview(iconImageView)
        backgroundBox.addSubview(symbolLabel)
        backgroundBox.addSubview(nameLabel)
        backgroundBox.addSubview(balanceLabel)
        backgroundBox.addSubview(amountLabel)
        backgroundBox.addSubview(priceLabel)
        backgroundBox.addSubview(changeLabel)
        
        setNeedsUpdateConstraints()
    }
    
    private func initValues() {
        
        if let crypto = self.crypto {
            
            DispatchQueue.main.async { self.iconImageView.setImage(from: crypto.iconURL) }
            symbolLabel.text = crypto.symbol
            nameLabel.text = crypto.name
            balanceLabel.text = crypto.balanceToString()
            amountLabel.text = crypto.amountToString()
            priceLabel.text = crypto.priceToString()
            changeLabel.setPercentMutableString(value: crypto.change, colors: true)
        }
    }

    // MARK: - Constraints
    
    override func makeConstraints() {
        
        backgroundBox.snp.makeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.top.equalTo(8)
            make.bottom.equalToSuperview().inset(8)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(29)
        }
        
        symbolLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.top.equalTo(CONTENT_TOP_MARGIN)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(symbolLabel)
            make.bottom.equalToSuperview().inset(CONTENT_BOTTOM_MARGIN)
            make.width.equalTo(60)
            make.height.equalTo(16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.centerX).offset(30)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(110)
            make.height.equalTo(20)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.right.equalTo(priceLabel)
            make.centerY.equalTo(nameLabel)
            make.width.equalTo(110)
            make.height.equalTo(16)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalToSuperview().offset(CONTENT_TOP_MARGIN)
            make.width.equalTo(110)
            make.height.equalTo(20)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.right.equalTo(balanceLabel)
            make.bottom.equalToSuperview().inset(CONTENT_BOTTOM_MARGIN)
            make.width.equalTo(110)
            make.height.equalTo(16)
        }
    }
    
}
