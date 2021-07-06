//
//  HomeHeaderView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 27/01/2021.
//

import UIKit
import SnapKit


class HomeHeaderView: BackgroundBoxView {
    
    lazy var portfolioLabel = UILabel()
    lazy var worthLabel = UILabel()
    lazy var changeLabel = UILabel()
    lazy var pnlLabel = UILabel()
    
    override func commonInit() {
        super.commonInit()
                 
        portfolioLabel.font = .systemFont(ofSize: 15, weight: .bold)
        portfolioLabel.textColor = AppColors.label.secondary
        
        worthLabel.font = .systemFont(ofSize: 34, weight: .semibold)
        
        changeLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        pnlLabel.font = .systemFont(ofSize: 15, weight: .semibold)

        addSubview(portfolioLabel)
        addSubview(worthLabel)
        addSubview(changeLabel)
        addSubview(pnlLabel)
        
        updateValues(portfolioName: "Main Portfolio", portfolioBalance: 84415.97, portfolioChange: -12.73, portfolioPNL: -8520.68)
    }
    
    func updateValues(portfolioName: String, portfolioBalance: Float, portfolioChange: Float, portfolioPNL: Float) {
        
        portfolioLabel.text = portfolioName
        worthLabel.setDollarMutableString(value: portfolioBalance)
        changeLabel.setPercentMutableString(value: portfolioChange, colors: true)
        pnlLabel.setDollarMutableString(value: portfolioPNL, colors: true)
    }
    
}


// MARK: - Constraints

extension HomeHeaderView {
    
    override func updateConstraints() {
        
        portfolioLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.right.equalTo(snp.centerX).inset(8)
            make.top.equalTo(CONTENT_TOP_MARGIN)
            make.height.equalTo(18)
        }
        
        worthLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(portfolioLabel.snp.bottom).offset(5)
            make.height.equalTo(41)
        }
        
        pnlLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.width.equalTo(pnlLabel.intrinsicContentSize.width)
            make.top.equalTo(worthLabel.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.left.equalTo(pnlLabel.snp.right).offset(5)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(worthLabel.snp.bottom).offset(5)
            make.height.equalTo(20).priority(999)
            make.bottom.equalToSuperview().inset(CONTENT_BOTTOM_MARGIN).priority(999)
        }
        
        super.updateConstraints()
    }
}
