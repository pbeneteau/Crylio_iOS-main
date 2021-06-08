//
//  HoldingsBalanceView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 07/05/2021.
//

import UIKit

class HoldingsBalanceView: RoundShadowView {

    lazy var title = UILabel()
    lazy var value = UILabel()
    
    lazy var progressBar = UIProgressView()
    lazy var ath = UILabel()
    lazy var percent = UILabel()
    
 
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
        
        backgroundColor = AppColors.background.secondary
        
        layer.cornerRadius = 10
        
        title.font = .systemFont(ofSize: 13)
        value.font = .systemFont(ofSize: 26, weight: .bold)
        percent.font = .systemFont(ofSize: 13, weight: .medium)
        ath.font = .systemFont(ofSize: 13)

        title.textColor = AppColors.label.secondary
        value.textColor = AppColors.label.primary
        percent.textColor = AppColors.label.primary
        ath.textColor = AppColors.label.secondary
        
        ath.textAlignment = .right
        percent.textAlignment = .center
        
        progressBar.progressTintColor = .systemTeal
        progressBar.trackTintColor = AppColors.label.secondary
        progressBar.clipsToBounds = true
        progressBar.progressViewStyle = .bar
        
        title.text = "Current Balance"
        ath.text = "ATH"
        
        addSubview(title)
        addSubview(value)
        addSubview(progressBar)
        addSubview(percent)
        addSubview(ath)
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        progressBar.layer.cornerRadius = progressBar.frame.height / 2
        
        percent.snp.remakeConstraints { make in
            make.centerX.equalTo(progressBar.subviews[1].frame.maxX + 16)
            make.top.equalTo(progressBar.snp.bottom).offset(5)
            make.width.equalTo(percent.intrinsicContentSize.width)
            make.height.equalTo(16)
        }
    }
    
}


// CONSTRAINTS

extension HoldingsBalanceView {
    
    override func updateConstraints() {
        
        title.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(CONTENT_TOP_MARGIN)
            make.width.equalTo(title.intrinsicContentSize.width)
            make.height.equalTo(16)
        }
        
        value.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(title.snp.bottom).offset(5)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.height.equalTo(31)
        }
        
        progressBar.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(value.snp.bottom).offset(15)
            make.height.equalTo(8)
        }
        
        percent.snp.makeConstraints { make in
            make.centerX.equalTo(progressBar.subviews[1].frame.maxX)
            make.top.equalTo(progressBar.snp.bottom).offset(5)
            make.width.equalTo(percent.intrinsicContentSize.width)
            make.height.equalTo(16)
        }
        
        ath.snp.makeConstraints { make in
            make.right.equalTo(progressBar)
            make.top.equalTo(progressBar.snp.bottom).offset(5)
            make.width.equalTo(ath.intrinsicContentSize.width)
            make.height.equalTo(16)
        }
        
        super.updateConstraints()
    }
    
    
}
