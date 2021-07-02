//
//  ChartBlockView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 01/02/2021.
//

import UIKit
import Charts

protocol CryptoDetailChartViewDelegate: NSObjectProtocol {
    
    func didTapPairButton()
    func didTapFullScreenButton()
    func didTapExchangeButton()
}

class CryptoDetailChartView: BackgroundBoxView, UIGestureRecognizerDelegate  {
        
    lazy var exchangeButton = UIButton()
    lazy var pairButton = UIButton()
    lazy var chartStyleButton = UIButton()
    
    lazy var tradingviewChartView = TradingviewChartView()
    lazy var dateRangeSelectorCV = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var fullscreenButton = UIButton()
    lazy var separatorView = UIView()
    
    weak var delegate: CryptoDetailChartViewDelegate!

    private let ranges = TradingviewChartDateRange.allCases

    override func commonInit() {
        super.commonInit()
        
        translatesAutoresizingMaskIntoConstraints = false
                
        exchangeButton.setTitleColor(AppColors.label.secondary, for: .normal)
        exchangeButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        exchangeButton.addTarget(self, action: #selector(didTapExchangeButton(_:)), for: .touchUpInside)
        exchangeButton.layer.borderWidth = 1
        exchangeButton.layer.borderColor = AppColors.label.secondary.cgColor
        exchangeButton.layer.cornerRadius = 8.91
        exchangeButton.clipsToBounds = true

        pairButton.setTitleColor(AppColors.label.secondary, for: .normal)
        pairButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        pairButton.addTarget(self, action: #selector(didTapPairButton(_:)), for: .touchUpInside)
        pairButton.layer.borderWidth = 1
        pairButton.layer.borderColor = AppColors.label.secondary.cgColor
        pairButton.layer.cornerRadius = 8.91
        pairButton.clipsToBounds = true

        let chartLineStyleButtonImage = UIImage(named: "lineChartButton")?.withRenderingMode(.alwaysTemplate)
        let chartDojiStyleButtonImage = UIImage(named: "dojiChartButton")?.withRenderingMode(.alwaysTemplate)
        chartStyleButton.setBackgroundImage(chartLineStyleButtonImage, for: .normal)
        chartStyleButton.setBackgroundImage(chartDojiStyleButtonImage, for: .selected)
        chartStyleButton.addTarget(self, action: #selector(didTapChartStyleButton(_:)), for: .touchUpInside)
        chartStyleButton.tintColor = .systemBlue
                
        let pairButtonImage = UIImage(named: "fullScreenButton")?.withRenderingMode(.alwaysTemplate)
        fullscreenButton.setBackgroundImage(pairButtonImage, for: .normal)
        fullscreenButton.addTarget(self, action: #selector(didTapFullscreenButton(_:)), for: .touchUpInside)
        fullscreenButton.tintColor = AppColors.label.secondary
        
        if let layout = dateRangeSelectorCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        dateRangeSelectorCV.register(DateRangeSelectorCollectionViewCell.self, forCellWithReuseIdentifier: DateRangeSelectorCollectionViewCell.reuseId)
        dateRangeSelectorCV.showsHorizontalScrollIndicator = false
        dateRangeSelectorCV.showsVerticalScrollIndicator = false
        dateRangeSelectorCV.contentInset = UIEdgeInsets(top: 0, left: CONTENT_HORIZONTAL_MARGIN, bottom: 0, right: CONTENT_HORIZONTAL_MARGIN)
        dateRangeSelectorCV.delegate = self
        dateRangeSelectorCV.dataSource = self
        dateRangeSelectorCV.backgroundColor = .clear
        dateRangeSelectorCV.clipsToBounds = true
        
        separatorView.backgroundColor = AppColors.label.secondary.withAlphaComponent(0.2)
        separatorView.layer.cornerRadius = 0
        separatorView.clipsToBounds = true
        
        dateRangeSelectorCV.reloadData()
        dateRangeSelectorCV.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
        
        addSubview(exchangeButton)
        addSubview(pairButton)
        addSubview(chartStyleButton)
        addSubview(tradingviewChartView)
        addSubview(dateRangeSelectorCV)
        addSubview(fullscreenButton)
        addSubview(separatorView)
    }
    
    func configure(with crypto: Cryptocurrency, exchange: TradingviewChartExchange, pair: String) {
        
        exchangeButton.setTitle(exchange.description, for: .normal)
        pairButton.setTitle(pair, for: .normal)

        tradingviewChartView.tradingviewChart = TradingviewChart(type: .small, symbol: crypto.symbol+pair, exchange: .binance)
    }
    
}


// MARK: - Delegates and gesture recognizers

extension CryptoDetailChartView {
    
    @objc func didTapExchangeButton(_ sender: UIButton) {
        
        if let delegate = delegate {
            delegate.didTapExchangeButton()
        }
    }
    
    @objc func didTapPairButton(_ sender: UIButton) {
                
        if let delegate = delegate {
            delegate.didTapPairButton()
        }
    }
    
    @objc func didTapChartStyleButton(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        print("chart style set to:", sender.isSelected ? "doji": "line")
        
        if sender.isSelected {
            tradingviewChartView.tradingviewChart.barStyle = .candles
        } else {
            tradingviewChartView.tradingviewChart.barStyle = .line
        }
        tradingviewChartView.reloadChart()
    }
    
    @objc func didTapFullscreenButton(_ sender: UIButton) {
        
        if let delegate = delegate {
            delegate.didTapFullScreenButton()
        }
    }
    
}


// MARK: - Collection view delegate and datasource

extension CryptoDetailChartView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ranges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = dateRangeSelectorCV.dequeueReusableCell(withReuseIdentifier: DateRangeSelectorCollectionViewCell.reuseId, for: indexPath) as? DateRangeSelectorCollectionViewCell  else {
            fatalError("The dequeued cell is not an instance of DateRangeSelectorCollectionViewCell.")
        }
        
        cell.dateRangeLabel.text = ranges[indexPath.row].description
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("selected date range: " + ranges[indexPath.row].description)
        
        tradingviewChartView.tradingviewChart.dateRange = ranges[indexPath.row]
        tradingviewChartView.reloadChart()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (ranges[indexPath.row].description as NSString).size(withAttributes: nil).width + 26
        return CGSize(width: width, height: 30)
    }
    
}


// MARK: - Constraints

extension CryptoDetailChartView {
    
    override func updateConstraints() {
        
        exchangeButton.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(CONTENT_TOP_MARGIN)
            make.width.equalTo(exchangeButton.intrinsicContentSize.width+26)
            make.height.equalTo(34)
        }
        
        pairButton.snp.makeConstraints { make in
            make.left.equalTo(exchangeButton.snp.right).offset(10)
            make.top.equalTo(CONTENT_TOP_MARGIN)
            make.width.equalTo(pairButton.intrinsicContentSize.width+26)
            make.height.equalTo(34)
        }
        
        chartStyleButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(CONTENT_TOP_MARGIN)
            make.width.height.equalTo(34)
        }
        
        tradingviewChartView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(exchangeButton.snp.bottom).offset(8)
            make.width.equalToSuperview()
            make.height.equalTo(374)
        }
        
        dateRangeSelectorCV.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(fullscreenButton.snp.left).offset(-16)
            make.top.equalTo(tradingviewChartView.snp.bottom).offset(10)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().inset(CONTENT_BOTTOM_MARGIN)
        }
        
        separatorView.snp.makeConstraints { make in
            make.left.equalTo(dateRangeSelectorCV.snp.right)
            make.top.equalTo(dateRangeSelectorCV)
            make.bottom.equalTo(dateRangeSelectorCV)
            make.width.equalTo(1)
        }
        
        fullscreenButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(tradingviewChartView.snp.bottom).offset(10)
            make.height.width.equalTo(30)
            make.bottom.equalToSuperview().inset(CONTENT_BOTTOM_MARGIN)
        }
        
        super.updateConstraints()
    }
    
}
