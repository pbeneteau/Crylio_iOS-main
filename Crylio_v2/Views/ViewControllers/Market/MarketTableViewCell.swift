//
//  MarketTableViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 07/06/2021.
//

import UIKit

class MarketTableViewCell: BaseTableViewCell {
    
    static let reuseId = "MarketTableViewCell"
    
    lazy var iconImageView = UIImageView()
    
    lazy var nameLabel = UILabel()
    lazy var rankLabel = UILabel()
    lazy var symbolLabel = UILabel()
    
    lazy var priceLabel = UILabel()
    lazy var changeLabel = UILabel()
    
    lazy var marketcapLabel = UILabel()
    lazy var volumeLabel = UILabel()
    
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
        
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        symbolLabel.font = .systemFont(ofSize: 15, weight: .medium)
        symbolLabel.textColor = AppColors.label.secondary
        
        rankLabel.textAlignment = .center
        rankLabel.font = .systemFont(ofSize: 12, weight: .medium)
        rankLabel.backgroundColor = .label.withAlphaComponent(0.1)
        rankLabel.layer.masksToBounds = true
        
        priceLabel.textAlignment = .right
        priceLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        changeLabel.textAlignment = .right
        changeLabel.font = .systemFont(ofSize: 15, weight: .medium)
        
        marketcapLabel.textAlignment = .right
        
        volumeLabel.textAlignment = .right
        volumeLabel.textColor = AppColors.label.secondary
        volumeLabel.font = .systemFont(ofSize: 15)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(rankLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(changeLabel)
        contentView.addSubview(marketcapLabel)
        contentView.addSubview(volumeLabel)
        
        setNeedsUpdateConstraints()
    }

    func configure(crypto: Cryptocurrency) {
        
        DispatchQueue.main.async { self.iconImageView.setImage(from: crypto.iconURL) }
        nameLabel.text = crypto.name
        symbolLabel.text = crypto.symbol
        rankLabel.text = String(crypto.id)
        priceLabel.text = crypto.price.toDollarString()
        changeLabel.setPercentMutableString(value: crypto.change, colors: true)
        marketcapLabel.text = "903.2B"
        volumeLabel.text = "89.3B"
    }
    
    // MARK: - Constraints
    
    override func makeConstraints() {
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.top.equalTo(14)
            make.height.width.equalTo(34)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.top.equalTo(9)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        rankLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.height.equalTo(18)
            make.width.equalTo(rankLabel.intrinsicContentSize.width).offset(18)
        }
        
        symbolLabel.snp.makeConstraints { make in
            make.left.equalTo(rankLabel.snp.right).offset(5)
            make.right.equalTo(nameLabel)
            make.centerY.equalTo(rankLabel)
            make.height.equalTo(18)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(130)
            make.centerY.equalTo(nameLabel)
            make.width.equalTo(125)
            make.height.equalTo(20)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.left.right.equalTo(priceLabel)
            make.centerY.equalTo(symbolLabel)
            make.height.equalTo(18)
        }
        
        marketcapLabel.snp.makeConstraints { make in
            make.left.equalTo(priceLabel).offset(8)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        volumeLabel.snp.makeConstraints { make in
            make.left.equalTo(changeLabel).offset(8)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.centerY.equalTo(symbolLabel)
            make.height.equalTo(18)
        }
        
        rankLabel.layer.cornerRadius = rankLabel.frame.height/2
    }
    
}
