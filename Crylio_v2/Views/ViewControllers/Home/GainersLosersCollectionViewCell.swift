//
//  GainersLosersCollectionViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 16/06/2021.
//

import UIKit


class GainersLosersCollectionViewCellModel: NSObject {

    var iconUrl: String
    var symbol: String
    var name: String
    var price: Float
    var change: Float
    var chartData: [Double]
    
    internal init(iconUrl: String, symbol: String, name: String, price: Float, change: Float, chartData: [Double]) {
        self.iconUrl = iconUrl
        self.symbol = symbol
        self.name = name
        self.price = price
        self.change = change
        self.chartData = chartData
    }
}


class GainersLosersCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "GainersLosersCollectionViewCell"
    
    lazy var backgroundBox = BackgroundBoxView()
    lazy var iconImageView = UIImageView()
    lazy var symbolLabel = UILabel()
    lazy var nameLabel = UILabel()
    lazy var priceLabel = UILabel()
    lazy var changeLabel = UILabel()
    lazy var chartView = BaseChartView()
    
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
        
        chartView.axesColor = .clear
        chartView.lineWidth = 1.5
        chartView.showXLabelsAndGrid = false
        chartView.showYLabelsAndGrid = false
        chartView.isUserInteractionEnabled = false
        
        contentView.addSubview(backgroundBox)
        backgroundBox.addSubview(iconImageView)
        backgroundBox.addSubview(symbolLabel)
        backgroundBox.addSubview(nameLabel)
        backgroundBox.addSubview(priceLabel)
        backgroundBox.addSubview(changeLabel)
        backgroundBox.addSubview(chartView)
    }
    
    func configure(with data: GainersLosersCollectionViewCellModel) {
        
        iconImageView.setImage(from: data.iconUrl)
        symbolLabel.text = data.symbol
        nameLabel.text = data.name
        priceLabel.text = data.price.toDollarString()
        changeLabel.setPercentMutableString(value: data.change, colors: true)
        
        updateChartData(with: data.chartData, change: data.change)
    }
    
    func updateChartData(with data: [Double], change: Float) {
        
        chartView.removeAllSeries()
                
        let series = ChartSeries(data)
        series.area = false
        
        if  change >= 0 {
            chartView.drawZeroLevelAxes = false
            series.color = AppColors.accent.green
        } else {
            chartView.drawZeroLevelAxes = false
            series.color = AppColors.accent.red
        }
        chartView.add(series)
    }
}


// MARK: - Constraints

extension GainersLosersCollectionViewCell {
    
    override func layoutIfNeeded() {
        
        backgroundBox.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(10)
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
        
        chartView.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(changeLabel.snp.bottom)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.bottom.equalToSuperview()
        }
        
        super.layoutIfNeeded()
    }
}
