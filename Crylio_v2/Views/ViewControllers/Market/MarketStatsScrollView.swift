//
//  MarketStatsScrollView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 04/06/2021.
//

import UIKit

class MarketStatsScrollView: UIScrollView {
    
    lazy var cryptosNumberLabel = UILabel()
    lazy var btcDominance = UILabel()
    lazy var dailyVolumeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        
        backgroundColor = .clear
        
        translatesAutoresizingMaskIntoConstraints = false
        contentInsetAdjustmentBehavior = .never
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        cryptosNumberLabel.font = .systemFont(ofSize: 15)
        btcDominance.font = .systemFont(ofSize: 15)
        dailyVolumeLabel.font = .systemFont(ofSize: 15)

        addSubview(cryptosNumberLabel)
        addSubview(btcDominance)
        addSubview(dailyVolumeLabel)
        
        initValues()
    }
    
    private func initValues() {
        
        let cryptosNumberLabelAttriText = NSMutableAttributedString(string: "Cryptos: " + Float(13515).toAmountString(), attributes: [NSAttributedString.Key.foregroundColor: AppColors.label.primary])
        
        cryptosNumberLabelAttriText.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.label.secondary, range: NSRange(location:0, length:"Cryptos:".count))
        
        let btcDominanceAttriText = NSMutableAttributedString(string: "BTC Dominance: " + Float(42.52).toPercentString(), attributes: [NSAttributedString.Key.foregroundColor: AppColors.label.primary])
        
        btcDominanceAttriText.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.label.secondary, range: NSRange(location:0, length: "BTC Dominance:".count))
        
        let dailyVolumeLabelAttriText = NSMutableAttributedString(string: "24h Vol: $110,6B", attributes: [NSAttributedString.Key.foregroundColor: AppColors.label.primary])
        
        dailyVolumeLabelAttriText.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.label.secondary, range: NSRange(location:0, length:"24h Vol:".count))
        
        cryptosNumberLabel.attributedText = cryptosNumberLabelAttriText
        btcDominance.attributedText = btcDominanceAttriText
        dailyVolumeLabel.attributedText = dailyVolumeLabelAttriText
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentSize = CGSize(width: dailyVolumeLabel.frame.maxX, height: self.frame.height)
    }

}


// MARK: - Constraints

extension MarketStatsScrollView {
    
    override func updateConstraints() {
        
        cryptosNumberLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.height.equalToSuperview()
            make.width.equalTo(cryptosNumberLabel.intrinsicContentSize.width)
        }
        
        btcDominance.snp.makeConstraints { make in
            make.left.equalTo(cryptosNumberLabel.snp.right).offset(10)
            make.centerY.height.equalToSuperview()
            make.width.equalTo(btcDominance.intrinsicContentSize.width)
        }
        
        dailyVolumeLabel.snp.makeConstraints { make in
            make.left.equalTo(btcDominance.snp.right).offset(10)
            make.centerY.height.equalToSuperview()
            make.width.equalTo(dailyVolumeLabel.intrinsicContentSize.width)
        }
        
        super.updateConstraints()
    }
}


