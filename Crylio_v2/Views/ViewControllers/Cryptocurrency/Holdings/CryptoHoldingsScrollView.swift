//
//  CryptoHoldingsScrollView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 08/02/2021.
//

import UIKit
import SnapKit


class CryptoHoldingsScrollView: UIScrollView {

    lazy var contentView = UIView()
    lazy var balanceView = HoldingsBalanceView()
    lazy var costView = HoldingsStatView()
    lazy var amountView = HoldingsStatView()
    lazy var profitLossView = HoldingsStatView()
    lazy var changeView = HoldingsStatView()

    lazy var distributionView = DistributionView(onOrder: 0.4, onTrade: 0.1, stacked: 0.3, available: 0.2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    init() {
        super.init(frame: CGRect.zero)
                
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        
        translatesAutoresizingMaskIntoConstraints = false
        contentInsetAdjustmentBehavior = .never
        showsHorizontalScrollIndicator = false
        
        contentView.backgroundColor = .clear
        
        addSubview(contentView)
        
        contentView.addSubview(balanceView)
        contentView.addSubview(costView)
        contentView.addSubview(amountView)
        contentView.addSubview(profitLossView)
        contentView.addSubview(changeView)
        contentView.addSubview(distributionView)
        
        initValues()
    }
    
    private func initValues() {
        
        costView.title.text = "Cost"
        amountView.title.text = "Amount"
        changeView.title.text = "Change"
        profitLossView.title.text = "Profit"
        
        if false {
            profitLossView.title.text = "Loss"
        }
        
        balanceView.value.setDollarMutableString(value: 13415.42)
        balanceView.progressBar.progress = 0.63
        balanceView.percent.text = Float(0.63*100).toPercentString()
        costView.value.text = Float(6421.74).toDollarString()
        amountView.value.text = Float(3.1).toAmountString(symbol: "BTC")
        changeView.value.setPercentMutableString(value: 1401.85, colors: true)
        profitLossView.value.setDollarMutableString(value: 120415.06, colors: true)
    }
    
    func updateInsets(menuMaxY: CGFloat) {
        contentInset = UIEdgeInsets(top: menuMaxY, left: 0, bottom: 0, right: 0)
        scrollIndicatorInsets = UIEdgeInsets(top: menuMaxY-20, left: 0, bottom: 0, right: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentSize = CGSize(width: frame.width, height: contentView.frame.height * 1.2)
    }

}


// MARKS: Constraints

extension CryptoHoldingsScrollView {
    
    override func updateConstraints() {
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.width.equalToSuperview().offset(-SAFE_AREA_MARGIN*2)
            make.height.equalTo(700)
        }
        
        balanceView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalToSuperview()
            make.top.equalTo(16)
            make.height.equalTo(126)
        }
        
        costView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(contentView.snp.centerX).offset(-8)
            make.top.equalTo(balanceView.snp.bottom).offset(16)
            make.height.equalTo(76)
        }
        
        amountView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.centerX).offset(8)
            make.right.equalToSuperview()
            make.top.equalTo(balanceView.snp.bottom).offset(16)
            make.height.equalTo(76)
        }
        
        profitLossView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(contentView.snp.centerX).offset(-8)
            make.top.equalTo(costView.snp.bottom).offset(16)
            make.height.equalTo(76)
        }
        
        changeView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.centerX).offset(8)
            make.right.equalToSuperview()
            make.top.equalTo(amountView.snp.bottom).offset(16)
            make.height.equalTo(76)
        }
        
        distributionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(profitLossView.snp.bottom).offset(30)
            make.height.equalTo(225)
        }
        
        super.updateConstraints()
    }
    
}
