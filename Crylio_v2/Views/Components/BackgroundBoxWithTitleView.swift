//
//  BackgroundBoxWithTitleView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 21/06/2021.
//

import UIKit

class BackgroundBoxWithTitleView: BaseView {
    
    lazy var titleLabel = UILabel()
    
    /// The corner radius
    var cornerRadius: CGFloat = 10 {
        didSet {
            updateProperties()
        }
    }
    
    override func commonInit() {
        super.commonInit()
        
        backgroundColor = AppColors.background.secondary
        layer.cornerRadius = cornerRadius
        
        titleLabel.font = .systemFont(ofSize: 21, weight: .bold)
        updateProperties()

        addSubview(titleLabel)

        setNeedsUpdateConstraints()
    }
    
    /**
     Updates all layer properties according to the public properties
     */
    fileprivate func updateProperties() {
        
        layer.cornerRadius = cornerRadius
    }
    
    override func makeConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(CONTENT_TOP_MARGIN)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.height.equalTo(titleLabel.intrinsicContentSize.height)
        }
    }
    
}
