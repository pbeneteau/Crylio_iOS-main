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

    lazy var backgroundBox = BackgroundBoxView()
    
    lazy var iconImageView = UIImageView()
    
    lazy var symbolLabel = UILabel()
    lazy var nameLabel = UILabel()
    
    //lazy var priceLabel = UILabel()
    lazy var changeLabel = UILabel()
    
    lazy var balanceLabel = UILabel()
    //lazy var amountLabel = UILabel()
    
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
                
        symbolLabel.font = .systemFont(ofSize: 17, weight: .medium)
                
        nameLabel.textColor = AppColors.label.secondary
        nameLabel.font = nameLabel.font.withSize(15)
        
        balanceLabel.textAlignment = .right
        balanceLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        changeLabel.textAlignment = .right
        changeLabel.font = .systemFont(ofSize: 15)
        
        //amountLabel.textColor = AppColors.label.secondary
        //amountLabel.textAlignment = .right
        //amountLabel.font = amountLabel.font.withSize(15)
        
        //priceLabel.textAlignment = .right
 
        contentView.addSubview(backgroundBox)
        backgroundBox.addSubview(iconImageView)
        backgroundBox.addSubview(symbolLabel)
        backgroundBox.addSubview(nameLabel)
        backgroundBox.addSubview(balanceLabel)
        //backgroundBox.addSubview(amountLabel)
        //backgroundBox.addSubview(priceLabel)
        backgroundBox.addSubview(changeLabel)
        
        setNeedsUpdateConstraints()
    }
    
    private func initValues() {
        
        if let crypto = self.crypto {
            
            DispatchQueue.main.async { self.iconImageView.setImage(from: crypto.iconURL) }
            symbolLabel.text = crypto.symbol
            nameLabel.text = crypto.name
            balanceLabel.text = crypto.balanceToString()
            //amountLabel.text = crypto.amountToString()
            //priceLabel.text = crypto.priceToString()
            changeLabel.setPercentMutableString(value: crypto.change, colors: true)
        }
    }

    // MARK: - Constraints
    
    override func makeConstraints() {
        
        backgroundBox.snp.makeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.top.equalTo(10)
            make.bottom.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(29)
        }
        
        symbolLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.right.equalTo(snp.centerX).inset(8)
            make.top.equalTo(CONTENT_TOP_MARGIN)
            make.height.equalTo(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.right.equalTo(snp.centerX).inset(8)
            make.bottom.equalToSuperview().inset(CONTENT_BOTTOM_MARGIN)
            make.height.equalTo(18)
        }
        
//        priceLabel.snp.makeConstraints { make in
//            make.right.equalTo(contentView.snp.centerX).offset(30)
//            make.top.equalToSuperview().offset(15)
//            make.width.equalTo(110)
//            make.height.equalTo(20)
//        }
        
//        amountLabel.snp.makeConstraints { make in
//            make.right.equalTo(balanceLabel)
//            make.bottom.equalToSuperview().inset(CONTENT_BOTTOM_MARGIN)
//            make.width.equalTo(110)
//            make.height.equalTo(16)
//        }
        
        balanceLabel.snp.makeConstraints { make in
            make.left.equalTo(snp.centerX).offset(8)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalToSuperview().offset(CONTENT_TOP_MARGIN)
            make.height.equalTo(20)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.left.equalTo(snp.centerX).offset(8)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.bottom.equalToSuperview().inset(CONTENT_BOTTOM_MARGIN)
            make.height.equalTo(18)
        }
        

        

    }
    
}
