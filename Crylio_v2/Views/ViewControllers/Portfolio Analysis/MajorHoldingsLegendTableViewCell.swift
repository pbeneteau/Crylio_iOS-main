//
//  MajorHoldingsLegendTableViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 21/06/2021.
//

import UIKit


struct MajorHoldingsLegendItem {
    
    var iconUrl: String
    var title: String
    var subtitle: String
}


class MajorHoldingsLegendTableViewCell: UITableViewCell {
    
    static let reuseId = "MajorHoldingsLegendTableViewCell"
    
    lazy var iconImageView = UIImageView()
    lazy var titleLabel = UILabel()
    lazy var subtitleLabel = UILabel()
    
    var item: AssetAllocationItem! {
        didSet {
            updateValues()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func commonInit() {
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        selectionStyle = .none
        
        iconImageView.backgroundColor = AppColors.background.secondary
        
        titleLabel.textColor = AppColors.label.primary
        subtitleLabel.textColor = AppColors.label.secondary
        
        titleLabel.font = .systemFont(ofSize: 15)
        subtitleLabel.font = .systemFont(ofSize: 13)
                
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        setNeedsUpdateConstraints()
    }
    
    private func updateValues() {
        
        iconImageView.setImage(from: item.iconURL)
        titleLabel.text = item.symbol
        subtitleLabel.text = item.name
    }

}


// MARK: - Constraints

extension MajorHoldingsLegendTableViewCell {
    
    override func updateConstraints() {
        
        iconImageView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(8)
            make.right.equalToSuperview()
            make.centerY.equalTo(iconImageView.snp.centerY)
            make.height.equalTo(18)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.right.equalToSuperview()
            make.height.equalTo(16)
        }
        
        super.updateConstraints()

    }
}
