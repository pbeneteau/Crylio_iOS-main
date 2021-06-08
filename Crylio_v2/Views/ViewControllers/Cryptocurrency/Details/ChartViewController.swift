//
//  ChartViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 11/05/2021.
//

import UIKit
import WebKit


protocol ChartViewControllerDelegate: NSObjectProtocol {
    
    func dateRangeDidChange(range: TradingViewChartDateRange)
}


class ChartViewController: UIViewController, WKNavigationDelegate {
    
    lazy var webView = WKWebView()
    var tradingViewChart: TradingViewChart!
    lazy var dateRangeSelectorCV = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let ranges = TradingViewChartDateRange.allCases
    
    weak var delegate: ChartViewControllerDelegate!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateRangeSelectorCV.backgroundColor = .clear
                
        initChartView()
        
        dateRangeSelectorCV.delegate = self
        dateRangeSelectorCV.dataSource = self
        
        if let layout = dateRangeSelectorCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        dateRangeSelectorCV.register(DateRangeSelectorCollectionViewCell.self, forCellWithReuseIdentifier: DateRangeSelectorCollectionViewCell.reuseId)
        dateRangeSelectorCV.showsHorizontalScrollIndicator = false
        dateRangeSelectorCV.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        dateRangeSelectorCV.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        view.addSubview(webView)
        view.addSubview(dateRangeSelectorCV)
 
        reloadChart()
    }
    
    
    func initChartView() {
        
        view.backgroundColor = AppColors.background.primary
        
        webView.navigationDelegate = self
        
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.isScrollEnabled = false
        //webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.bounces = false
        webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    func reloadChart(range: TradingViewChartDateRange = .day) {
        
        webView.loadHTMLString(tradingViewChart.getFullChart(with: range), baseURL: nil)
    }
}

// MARK: - Collection view delegate and datasource

extension ChartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        reloadChart(range: ranges[indexPath.row])
        dateRangeDidChange(range: ranges[indexPath.row])
        print("selected date range: " + ranges[indexPath.row].description)
    }
    
}

// MARK: - Chart view controller delegate

extension ChartViewController: ChartViewControllerDelegate {
    
    func dateRangeDidChange(range: TradingViewChartDateRange) {
        if let delegate = delegate {
            delegate.dateRangeDidChange(range: range)
        }
    }
}


// MARK: - Constraints

extension ChartViewController {
    
    override func updateViewConstraints() {
        
        webView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().inset(90)
            make.width.equalToSuperview()
        }
        
        dateRangeSelectorCV.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(webView.snp.bottom).offset(5)
            make.height.equalTo(50)
        }

        super.updateViewConstraints()
    }
}


// MARK: - Interface style handling for chart

extension ChartViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        tradingViewChart.theme = traitCollection.userInterfaceStyle == .dark ? .dark: .light
        reloadChart()
    }
}
