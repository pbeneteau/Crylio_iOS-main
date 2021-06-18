//
//  TranscationCellView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 17/06/2021.
//

import UIKit


class TransactionCellView: BaseView {
    
    lazy var transactionTypeImageView = UIImageView()
    lazy var transactionTypeLabel = UILabel()
    lazy var amountLabel = UILabel()
    lazy var exchangeLabel = UILabel()
    lazy var worthLabel = UILabel()
    lazy var dateLabel = UILabel()
    lazy var filledStatusLabel = UILabel()
    
    var transaction: Transaction! {
        didSet {
            initValues()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        
        transactionTypeLabel.font = .systemFont(ofSize: 17)
        
        exchangeLabel.font = .systemFont(ofSize: 15)
        exchangeLabel.textColor = AppColors.label.secondary
        
        amountLabel.textAlignment = .right
        amountLabel.font = .systemFont(ofSize: 15)
        amountLabel.textColor = AppColors.label.secondary
        
        dateLabel.textColor = AppColors.label.secondary
        dateLabel.font = .systemFont(ofSize: 13)
        
        worthLabel.textAlignment = .right
        worthLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        filledStatusLabel.layer.cornerRadius = 3
        filledStatusLabel.clipsToBounds = true
        filledStatusLabel.backgroundColor = AppColors.label.secondary.withAlphaComponent(0.2)
        filledStatusLabel.textColor = AppColors.label.secondary
        filledStatusLabel.textAlignment = .center
        filledStatusLabel.font = .systemFont(ofSize: 13)
        
        addSubview(transactionTypeImageView)
        addSubview(transactionTypeLabel)
        addSubview(amountLabel)
        addSubview(exchangeLabel)
        addSubview(worthLabel)
        addSubview(dateLabel)
        addSubview(filledStatusLabel)
    }
    
    func initValues() {
        
        transactionTypeLabel.text = transaction.type.rawValue
        filledStatusLabel.text = transaction.status.rawValue
        
        exchangeLabel.text =  "via " + transaction.exchange
        if transaction.type == .transferOut || transaction.type == .transferIn {
            exchangeLabel.text = "to " + transaction.exchange
        }
        exchangeLabel.setSpannedColor(fullText: exchangeLabel.text!, changeText: transaction.exchange, color: .label)
        worthLabel.setDollarMutableString(value: transaction.worth)
        amountLabel.text = transaction.amount.toAmountString() + " \(transaction.asset.symbol)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .medium
        dateLabel.text = dateFormatter.string(from: transaction.time)
        
        
        switch transaction.type {
        case .marketSell:
            transactionTypeImageView.image = UIImage(named: "decreaseArrow")
        case .marketBuy:
            transactionTypeImageView.image = UIImage(named: "increaseArrow")
        case .limitBuy:
            transactionTypeImageView.image = UIImage(named: "increaseArrow")
        case .limitSell:
            transactionTypeImageView.image = UIImage(named: "decreaseArrow")
        case .transferIn:
            transactionTypeImageView.image = UIImage(named: "transferIn")
        case .transferOut:
            transactionTypeImageView.image = UIImage(named: "transferOut")
        }
    }
    
    override func makeConstraints() {
        
        transactionTypeImageView.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(20)
            make.height.width.equalTo(29)
        }
        
        transactionTypeLabel.snp.makeConstraints { make in
            make.left.equalTo(transactionTypeImageView.snp.right).offset(8)
            make.top.equalTo(CONTENT_TOP_MARGIN)
            make.right.equalTo(snp.centerX).offset(-8)
            make.height.equalTo(20)
        }
        
        exchangeLabel.snp.makeConstraints { make in
            make.left.equalTo(transactionTypeLabel)
            make.right.equalTo(transactionTypeLabel)
            make.top.equalTo(transactionTypeLabel.snp.bottom).offset(4)
            make.height.equalTo(18)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(exchangeLabel)
            make.right.equalTo(snp.centerX).offset(-8)
            make.bottom.equalToSuperview().offset(-CONTENT_BOTTOM_MARGIN)
            make.height.equalTo(20)
        }
        
        worthLabel.snp.makeConstraints { make in
            make.left.equalTo(snp.centerX).offset(8)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalTo(transactionTypeLabel)
            make.height.equalTo(20)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(snp.centerX).offset(8)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalTo(exchangeLabel)
            make.height.equalTo(18)
        }
        
        filledStatusLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalTo(dateLabel)
            make.width.equalTo(filledStatusLabel.intrinsicContentSize.width + 8)
            make.height.equalTo(20)
        }
    }
    
}


final class TransactionCellDetailView: BaseView, ChartDelegate {
    
    lazy var stackView = UIStackView()
    lazy var chartView = Chart()
    lazy var dataView = UIView()
    lazy var pnlLabel = UILabel()
    lazy var worthLabel = UILabel()
    lazy var highlightedValueLabel = UILabel()
        
    var transaction: Transaction! {
        didSet {
            initValues()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        
        stackView.clipsToBounds = true
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        
        chartView.delegate = self
        chartView.axesColor = .clear
        chartView.lineWidth = 1.5
        chartView.showXLabelsAndGrid = false
        chartView.showYLabelsAndGrid = false
        chartView.hideHighlightLineOnTouchEnd = true
        
        pnlLabel.numberOfLines = 2

        worthLabel.numberOfLines = 2
        worthLabel.textAlignment = .right
        
        highlightedValueLabel.font = .systemFont(ofSize: 13)
        highlightedValueLabel.textColor = AppColors.label.secondary
        highlightedValueLabel.textAlignment = .center
        highlightedValueLabel.backgroundColor = AppColors.background.secondary
        
        translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        dataView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        addSubview(highlightedValueLabel)
        dataView.addSubview(pnlLabel)
        dataView.addSubview(worthLabel)
        stackView.addArrangedSubview(chartView)
        stackView.addArrangedSubview(dataView)
                
        setNeedsUpdateConstraints()
    }
    
    func initValues() {
        
        let accentColor: UIColor = transaction.allTimePNL >= 0 ? AppColors.accent.green: AppColors.accent.red
        
        let pnlTitleString = transaction.allTimePNL >= 0 ? "Profit\n": "Loss\n"
        let pnlValueString = "\(transaction.allTimeChange.toPercentString()) (\(transaction.allTimePNL.toDollarString()))"
                
        let pnlAttriText = NSMutableAttributedString(string: pnlTitleString + pnlValueString, attributes: [NSAttributedString.Key.foregroundColor: accentColor])
        
        pnlAttriText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 13, weight: .regular), range: NSRange(location:0, length: pnlTitleString.count))
        
        pnlAttriText.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.label.secondary, range: NSRange(location:0, length: pnlTitleString.count))
        
        let worthAttriText = NSMutableAttributedString(string: "Current value\n" + transaction.currentValue.toDollarString(), attributes: [NSAttributedString.Key.foregroundColor: AppColors.label.primary])
        
        worthAttriText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 13, weight: .regular), range: NSRange(location:0, length:"Current value".count))
        
        worthAttriText.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.label.secondary, range: NSRange(location:0, length:"Current value".count))
        
        pnlLabel.attributedText = pnlAttriText
        worthLabel.attributedText = worthAttriText
        updateChartData()
    }
    
    func updateChartData() {
        
        chartView.removeAllSeries()
        
        let data: [Double] = (1...40).map {_ in Double.random(in: 300...600)}
        
        let series = ChartSeries(data)
        series.area = false
        
        if let min = data.min(), transaction.price <= Float(min) {
            chartView.drawZeroLevelAxes = false
            series.color = AppColors.accent.green
        } else if let max = data.max(), transaction.price >= Float(max) {
            chartView.drawZeroLevelAxes = false
            series.color = AppColors.accent.red
        } else {
            if transaction.type == .limitBuy || transaction.type == .marketBuy {
                series.colors = (
                    above: AppColors.accent.green,
                    below: AppColors.label.secondary.withAlphaComponent(0.5),
                    zeroLevel: Double(transaction.price)
                )
            } else {
                series.colors = (
                    above: AppColors.label.secondary.withAlphaComponent(0.5),
                    below: AppColors.accent.green,
                    zeroLevel: Double(transaction.price)
                )
            }
            
        }
        
        chartView.add(series)
    }
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {
        
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if dataIndex != nil {
                // The series at `seriesIndex` is that which has been touched
                if let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
                    highlightedValueLabel.isHidden = false
                    highlightedValueLabel.text = Float(value).toDollarString()
                }
                highlightedValueLabel.snp.remakeConstraints { make in
                    make.centerX.equalTo(CGFloat(left))
                    make.width.equalTo(highlightedValueLabel.intrinsicContentSize.width)
                    make.top.equalTo(chartView)
                    make.height.equalTo(highlightedValueLabel.intrinsicContentSize.height)
                }
                layoutIfNeeded()
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        highlightedValueLabel.isHidden = true
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        highlightedValueLabel.isHidden = true
    }
    
    override func makeConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(133)
        }
        
        pnlLabel.snp.makeConstraints { make in
            make.left.equalTo(51)
            make.right.equalTo(worthLabel.snp.left).offset(-8)
            make.top.bottom.equalToSuperview()
        }
        
        worthLabel.snp.makeConstraints { make in
            make.left.equalTo(pnlLabel.snp.right).offset(8)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.top.bottom.equalToSuperview()
        }
    }

}
