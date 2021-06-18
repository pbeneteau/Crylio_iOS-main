//
//  GainersLosersCollectionViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 16/06/2021.
//

import UIKit


class GainersLosersCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "GainersLosersCollectionViewCell"
    
    lazy var backgroundBox = RoundShadowView()
    lazy var iconImageView = UIImageView()
    lazy var symbolLabel = UILabel()
    lazy var nameLabel = UILabel()
    lazy var priceLabel = UILabel()
    lazy var changeLabel = UILabel()
    lazy var lineChartView = CustomLineChartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        backgroundBox.translatesAutoresizingMaskIntoConstraints = false
        backgroundBox.shadowOpacity = 0.05
        
        symbolLabel.font = .systemFont(ofSize: 15, weight: .regular)
        nameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        priceLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        changeLabel.font = .systemFont(ofSize: 15, weight: .medium)
        
        nameLabel.textColor = AppColors.label.secondary
        
        lineChartView.lineColor = .white
        lineChartView.lineWidth = 1
        lineChartView.fillColor = .clear
        lineChartView.shadow = false
        lineChartView.pointEntries = generateRandomEntries()
        
        contentView.addSubview(backgroundBox)
        backgroundBox.addSubview(iconImageView)
        backgroundBox.addSubview(symbolLabel)
        backgroundBox.addSubview(nameLabel)
        backgroundBox.addSubview(priceLabel)
        backgroundBox.addSubview(changeLabel)
        backgroundBox.addSubview(lineChartView)
    }
    
    private func generateRandomEntries() -> [PointEntry] {
        
        var result: [PointEntry] = []
        for i in 0..<40 {
            let value = Float.random(in: 50000...100000)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            
            result.append(PointEntry(value: value, label: formatter.string(from: date)))
        }
        return result
    }
}


// MARK: - Constraints

extension GainersLosersCollectionViewCell {
    
    override func layoutIfNeeded() {
        
        backgroundBox.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(CONTENT_TOP_MARGIN)
            make.width.height.equalTo(24)
        }
        
        symbolLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(5)
            make.top.equalTo(CONTENT_TOP_MARGIN)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.height.equalTo(18)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(5)
            make.top.equalTo(symbolLabel.snp.bottom).offset(1)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.height.equalTo(16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.height.equalTo(20)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.height.equalTo(18)
        }
        
        lineChartView.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(changeLabel.snp.bottom).offset(2)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.bottom.equalToSuperview()
        }
        
        super.layoutIfNeeded()
    }
}
