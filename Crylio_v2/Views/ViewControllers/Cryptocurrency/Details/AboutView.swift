//
//  AboutView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 08/02/2021.
//

import UIKit

class AboutView: BackgroundBoxWithTitleView {
    
    lazy var descriptionTextLabel = UILabel()
    
    var descriptionString: String! {
        didSet {
            descriptionTextLabel.text = descriptionString!
        }
    }
    
    var name: String! {
        didSet {
            titleLabel.text = "About \(name!)"
        }
    }

    override func commonInit() {
        super.commonInit()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        descriptionTextLabel.font = .systemFont(ofSize: 17)
        descriptionTextLabel.textColor = AppColors.label.secondary
        descriptionTextLabel.numberOfLines = 0
        descriptionTextLabel.sizeToFit()
        
        addSubview(descriptionTextLabel)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        descriptionTextLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.bottom.equalToSuperview().offset(-CONTENT_BOTTOM_MARGIN)
        }
    }

}
