//
//  BalanceView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 07/05/2021.
//

import UIKit

class BalanceView: BaseView {

    lazy var titleLabel = UILabel()
    lazy var valueLabel = UILabel()
    
    lazy var progressBar = UIProgressView()
    lazy var ath = UILabel()
    lazy var percent = UILabel()
    
    override func commonInit() {
        super.commonInit()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .clear
                
        titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        valueLabel.font = .systemFont(ofSize: 26, weight: .bold)
        percent.font = .systemFont(ofSize: 13, weight: .medium)
        ath.font = .systemFont(ofSize: 13, weight: .medium)

        titleLabel.textColor = AppColors.label.secondary
        valueLabel.textColor = AppColors.label.primary
        percent.textColor = AppColors.label.primary
        ath.textColor = AppColors.label.secondary
        
        ath.textAlignment = .right
        percent.textAlignment = .center
        
        progressBar.progressTintColor = .systemTeal
        progressBar.trackTintColor = AppColors.background.tertiary
        progressBar.clipsToBounds = true
        progressBar.progressViewStyle = .bar
        
        titleLabel.text = "Current Balance"
        ath.text = "ATH"
        
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(progressBar)
        addSubview(percent)
        addSubview(ath)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        progressBar.layer.cornerRadius = progressBar.frame.height/2
        
        percent.snp.remakeConstraints { make in
            make.centerX.equalTo(min(progressBar.subviews[1].frame.maxX+16, ath.frame.minX-percent.frame.width/2-5))
            make.top.equalTo(progressBar.snp.bottom).offset(5)
            make.width.equalTo(percent.intrinsicContentSize.width)
            make.height.equalTo(16)
        }
    }
    
}


// CONSTRAINTS

extension BalanceView {
    
    override func updateConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(CONTENT_TOP_MARGIN)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.height.equalTo(16)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.height.equalTo(31)
        }
        
        progressBar.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(valueLabel.snp.bottom).offset(15)
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
