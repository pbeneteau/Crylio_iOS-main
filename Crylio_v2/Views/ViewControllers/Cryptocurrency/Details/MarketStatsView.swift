//
//  MarketStatsView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 05/02/2021.
//

import UIKit

class MarketStatsView: UIView {
    
    lazy var titleLabel = UILabel()
    
    lazy var backgroundBoxView = RoundShadowView()
    
    lazy var volumeIcon = UIImageView(image: UIImage(named: "volumeIcon")!.withRenderingMode(.alwaysTemplate))
    lazy var marketCapIcon = UIImageView(image: UIImage(named: "marketCapIcon")!.withRenderingMode(.alwaysTemplate))
    lazy var availableSupplyIcon = UIImageView(image: UIImage(named: "availableSupplyIcon")!.withRenderingMode(.alwaysTemplate))
    lazy var totalSupplyIcon = UIImageView(image: UIImage(named: "totalSupplyIcon")!.withRenderingMode(.alwaysTemplate))
    
    lazy var volume24TitleLabel = UILabel()
    lazy var volume24Label = UILabel()
    lazy var volume24ChangeLabel = UILabel()
    lazy var marketCapTitleLabel = UILabel()
    lazy var marketCapLabel = UILabel()
    lazy var marketCapChangeLabel = UILabel()
    lazy var availableSupplyTitleLabel = UILabel()
    lazy var availableSupplyLabel = UILabel()
    lazy var availableSupplyChangeLabel = UILabel()
    lazy var totalSupplyTitleLabel = UILabel()
    lazy var totalSupplyLabel = UILabel()
    
    var marketStats: CryptoMarketStats! {
        didSet {
            initValues()
        }
    }
    
    
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
        
        backgroundColor = .clear
        backgroundBoxView.backgroundColor = AppColors.background.secondary
        
        backgroundBoxView.layer.cornerRadius = 10
        
        titleLabel.text = "Market Stats"
        
        volume24TitleLabel.text = "Volume 24h"
        marketCapTitleLabel.text = "Market Cap"
        availableSupplyTitleLabel.text = "Available Supply"
        totalSupplyTitleLabel.text = "Total Supply"
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        volume24TitleLabel.font = .systemFont(ofSize: 13)
        volume24Label.font = .systemFont(ofSize: 17, weight: .medium)
        volume24ChangeLabel.font = .systemFont(ofSize: 15)
        marketCapTitleLabel.font = .systemFont(ofSize: 13)
        marketCapLabel.font = .systemFont(ofSize: 17, weight: .medium)
        marketCapChangeLabel.font = .systemFont(ofSize: 15)
        availableSupplyTitleLabel.font = .systemFont(ofSize: 13)
        availableSupplyLabel.font = .systemFont(ofSize: 17, weight: .medium)
        availableSupplyChangeLabel.font = .systemFont(ofSize: 15)
        totalSupplyTitleLabel.font = .systemFont(ofSize: 13)
        totalSupplyLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        titleLabel.textColor = .label
        
        volume24TitleLabel.textColor = .systemGray
        marketCapTitleLabel.textColor = .systemGray
        availableSupplyTitleLabel.textColor = .systemGray
        totalSupplyTitleLabel.textColor = .systemGray
        
        volume24ChangeLabel.textAlignment = .right
        marketCapChangeLabel.textAlignment = .right
        availableSupplyChangeLabel.textAlignment = .right
        
        volumeIcon.tintColor = AppColors.icon
        marketCapIcon.tintColor = AppColors.icon
        availableSupplyIcon.tintColor = AppColors.icon
        totalSupplyIcon.tintColor = AppColors.icon
                
        addSubview(titleLabel)
        addSubview(backgroundBoxView)
        
        backgroundBoxView.addSubview(volumeIcon)
        backgroundBoxView.addSubview(marketCapIcon)
        backgroundBoxView.addSubview(availableSupplyIcon)
        backgroundBoxView.addSubview(totalSupplyIcon)
        
        backgroundBoxView.addSubview(volume24TitleLabel)
        backgroundBoxView.addSubview(volume24Label)
        backgroundBoxView.addSubview(volume24ChangeLabel)
        backgroundBoxView.addSubview(marketCapTitleLabel)
        backgroundBoxView.addSubview(marketCapLabel)
        backgroundBoxView.addSubview(marketCapChangeLabel)
        backgroundBoxView.addSubview(availableSupplyTitleLabel)
        backgroundBoxView.addSubview(availableSupplyLabel)
        backgroundBoxView.addSubview(availableSupplyChangeLabel)
        backgroundBoxView.addSubview(totalSupplyTitleLabel)
        backgroundBoxView.addSubview(totalSupplyLabel)
        
    }
    
    func initValues() {
        
        volume24Label.setDollarMutableString(value: marketStats.volume24, precision: 0)
        volume24ChangeLabel.setPercentMutableString(value: marketStats.volume24Change, colors: true)
        marketCapLabel.setDollarMutableString(value: marketStats.marketCap, precision: 0)
        marketCapChangeLabel.setPercentMutableString(value: marketStats.marketCapChange, colors: true)
        availableSupplyLabel.setAmountMutableString(value: marketStats.availableSupply)
        availableSupplyChangeLabel.setPercentMutableString(value: marketStats.availableSupplyChange, colors: true)
        totalSupplyLabel.setAmountMutableString(value: marketStats.totalSupply)
        
    }
    
    override func updateConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(22)
        }
        
        backgroundBoxView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        volumeIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.width.height.equalTo(32)
        }
        volume24TitleLabel.snp.makeConstraints { make in
            make.left.equalTo(volumeIcon.snp.right).offset(15)
            make.top.equalTo(volumeIcon).offset(-5)
            make.width.equalTo(150)
            make.height.equalTo(16)
        }
        volume24Label.snp.makeConstraints { make in
            make.left.equalTo(volumeIcon.snp.right).offset(15)
            make.bottom.equalTo(volumeIcon).offset(3)
            make.width.equalTo(volume24Label.intrinsicContentSize.width)
            make.height.equalTo(20)
        }
        volume24ChangeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalTo(volume24Label)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
        marketCapIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(volumeIcon.snp.bottom).offset(30)
            make.width.height.equalTo(32)
        }
        marketCapTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(marketCapIcon.snp.right).offset(15)
            make.top.equalTo(marketCapIcon).offset(-5)
            make.width.equalTo(150)
            make.height.equalTo(16)
        }
        marketCapLabel.snp.makeConstraints { make in
            make.left.equalTo(marketCapIcon.snp.right).offset(15)
            make.bottom.equalTo(marketCapIcon).offset(3)
            make.width.equalTo(marketCapLabel.intrinsicContentSize.width)
            make.height.equalTo(20)
        }
        marketCapChangeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalTo(marketCapLabel)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
        availableSupplyIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(marketCapIcon.snp.bottom).offset(30)
            make.width.height.equalTo(32)
        }
        availableSupplyTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(availableSupplyIcon.snp.right).offset(15)
            make.top.equalTo(availableSupplyIcon).offset(-5)
            make.width.equalTo(150)
            make.height.equalTo(16)
        }
        availableSupplyLabel.snp.makeConstraints { make in
            make.left.equalTo(availableSupplyIcon.snp.right).offset(15)
            make.bottom.equalTo(availableSupplyIcon).offset(3)
            make.width.equalTo(availableSupplyLabel.intrinsicContentSize.width)
            make.height.equalTo(20)
        }
        availableSupplyChangeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalTo(availableSupplyLabel)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
        totalSupplyIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(availableSupplyIcon.snp.bottom).offset(30)
            make.width.height.equalTo(32)
        }
        totalSupplyTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(totalSupplyIcon.snp.right).offset(15)
            make.top.equalTo(totalSupplyIcon).offset(-5)
            make.width.equalTo(150)
            make.height.equalTo(16)
        }
        totalSupplyLabel.snp.makeConstraints { make in
            make.left.equalTo(totalSupplyIcon.snp.right).offset(15)
            make.bottom.equalTo(totalSupplyIcon).offset(3)
            make.width.equalTo(totalSupplyLabel.intrinsicContentSize.width)
            make.height.equalTo(20)
        }
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Manually set subview frames here
    }
}
