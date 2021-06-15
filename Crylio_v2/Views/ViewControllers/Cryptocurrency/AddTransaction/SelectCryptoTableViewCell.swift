//
//  SelectCryptoTableViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 15/06/2021.
//

import UIKit

class SelectCryptoTableViewCell: UITableViewCell {
    
    static let reuseId = "SelectCryptoTableViewCell"
    
    lazy var iconImageView = UIImageView()
    
    lazy var symbolLabel = UILabel()
    lazy var nameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        selectionStyle = .blue
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        nameLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        symbolLabel.font = .systemFont(ofSize: 15)
        symbolLabel.tintColor = AppColors.label.secondary
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(nameLabel)
    }
    
}


// MARK: - Constraints

extension SelectCryptoTableViewCell {
    
    override func layoutIfNeeded() {
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(contentView.snp.height).multipliedBy(0.7)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(nameLabel.intrinsicContentSize.width)
            make.height.equalTo(20)
        }
        
        symbolLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.height.equalTo(16)
        }
        
        super.layoutIfNeeded()
    }
    
}
