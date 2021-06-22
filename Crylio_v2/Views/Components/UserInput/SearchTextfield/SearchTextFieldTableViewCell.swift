//
//  SearchTextFieldTableViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 26/05/2021.
//

import UIKit

class SearchTextFieldTableViewCell: UITableViewCell {
    
    static let reuseId = "SearchTextFieldTableViewCell"

    lazy var selectionView = BackgroundBoxView()
    lazy var image = UIImageView()
    lazy var titleLabel = UILabel()
        
    var content: (title:String, image:UIImage?)! {
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
    }
        
    private func commonInit() {
                        
        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        selectionView.isHidden = true
        selectionView.layer.cornerRadius = 7
        selectionView.backgroundColor = AppColors.selectionBackground
        
        addSubview(selectionView)
        addSubview(image)
        addSubview(titleLabel)
    }
    
    private func initValues() {
        
        titleLabel.text = content.title
        image.image = content.image
    }
    
    
}


// MARK: - Constraints

extension SearchTextFieldTableViewCell {
    
    override func layoutIfNeeded() {
        
        selectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(7)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(7)
            make.height.equalToSuperview()
        }
        
        if content.image != nil {
            image.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(14)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(31)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.left.equalTo(image.snp.right).offset(7)
                make.centerY.equalToSuperview()
                make.height.equalTo(20)
                make.right.equalToSuperview().inset(14)
            }
        } else {
            
            titleLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(14)
                make.centerY.equalToSuperview()
                make.height.equalTo(20)
                make.right.equalToSuperview().inset(14)
            }
        }
        
        super.layoutIfNeeded()
    }
}
