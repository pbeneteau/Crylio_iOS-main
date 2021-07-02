//
//  SelectionTableViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 15/06/2021.
//

import UIKit

class SelectionTableViewCell: BaseTableViewCell {
    
    static let reuseId = "SelectCryptoTableViewCell"
    
    lazy var iconImageView = UIImageView()
    
    lazy var titleLabel = UILabel()
    lazy var descriptionLabel = UILabel()

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
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .regular)
        descriptionLabel.textColor = AppColors.label.secondary

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        setNeedsUpdateConstraints()
    }
    
    // MARK: - Constraints
    
    override func makeConstraints() {
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(contentView.snp.height).multipliedBy(0.6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(titleLabel.intrinsicContentSize.width)
            make.height.equalTo(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.height.equalTo(20)
        }
    }
    
}
