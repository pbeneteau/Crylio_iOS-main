//
//  ChartBlockView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 01/02/2021.
//

import UIKit
import WebKit


protocol CryptoDetailsChartViewDelegate: AnyObject {
    
    func chartViewDoubleTapped()
}

class ChartView: BackgroundBoxView, UIGestureRecognizerDelegate {
        
    lazy var chartView = WKWebView()
    lazy var dateRangePicker = UISegmentedControl(items: ["1d", "1m", "3m", "1y", "all"])
    
    weak var delegate: CryptoDetailsChartViewDelegate!
    
    override func commonInit() {
        super.commonInit()
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        chartView.backgroundColor = .clear
        chartView.allowsBackForwardNavigationGestures = false
        chartView.scrollView.isScrollEnabled = false
        chartView.scrollView.showsVerticalScrollIndicator = false
        chartView.scrollView.bounces = false
        chartView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        chartView.scrollView.contentInsetAdjustmentBehavior = .never
        chartView.navigationDelegate = self
        chartView.allowsLinkPreview = false
        chartView.clipsToBounds = true
        chartView.layer.cornerRadius = layer.cornerRadius
        //chartView.isUserInteractionEnabled = false
                
        let tap = UITapGestureRecognizer(target: self, action: #selector(chartViewDoubleTapped))
        tap.delegate = self
        tap.numberOfTapsRequired = 2
        
        chartView.addGestureRecognizer(tap)
        
        dateRangePicker.selectedSegmentIndex = 0
        dateRangePicker.backgroundColor = AppColors.background.secondary
        dateRangePicker.selectedSegmentTintColor = AppColors.background.secondary
        
        addSubview(chartView)
        addSubview(dateRangePicker)
        
        reloadChart()
    }
    
    func reloadChart(dateRange: TradingViewChartDateRange = .day) {
        
        let t = TradingViewChart(symbol: "BTCUSDT", exchange: .binance, theme: .dark)
        chartView.loadHTMLString(t.getMinimizedChart(with: dateRange), baseURL: nil)
    }
    
    @objc func chartViewDoubleTapped() {
        
        delegate.chartViewDoubleTapped()
    }
    
}


// MARK: - Constraints

extension ChartView {
    
    override func updateConstraints() {
        
        chartView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(374)
        }
        
        dateRangePicker.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(chartView.snp.bottom).offset(10)
            make.height.equalTo(29)
        }
        
        super.updateConstraints()
    }
    
}


// MARK: - Chart view delegate

extension ChartView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
                
        guard case .linkActivated = navigationAction.navigationType,
              let url = navigationAction.request.url
        else {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)
        UIApplication.shared.open(url)
   }
        
}
