//
//  TradingviewChartView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 02/07/2021.
//

import UIKit
import WebKit


class TradingviewChartView: BaseView, WKNavigationDelegate {
    
    lazy var webView = WKWebView()
    
    var tradingviewChart: TradingviewChart! {
        didSet {
            reloadChart()
        }
    }
    
    override func commonInit() {
        super.commonInit()
        
        backgroundColor = .clear
        initWebView()
    }
    
    func initWebView() {
                
        webView.isOpaque = false
        webView.scrollView.backgroundColor = .clear
        webView.backgroundColor = .clear
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.bounces = false
        webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsLinkPreview = false
        webView.clipsToBounds = true
        webView.layer.cornerRadius = layer.cornerRadius
        webView.navigationDelegate = self
        
        addSubview(webView)
    }
    
    func reloadChart() {
        
        tradingviewChart.theme = traitCollection.userInterfaceStyle == .dark ? .dark : .light
        webView.loadHTMLString(tradingviewChart.getChart(), baseURL: nil)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
