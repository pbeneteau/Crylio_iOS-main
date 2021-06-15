//
//  CryptoDetailViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 08/02/2021.
//

import UIKit
import Hero


class CryptoDetailViewController: BaseViewController {
    
    var blurredHeaderViewAlpha: CGFloat = 0.0
    
    lazy var scrollView = CryptoDetailScrollView()
    weak var scrollViewDelegate: ScrollViewDidScrollDelegate?

    var refreshControl = UIRefreshControl()
    
    var crypto: Cryptocurrency!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.crypto = crypto
        scrollView.delegate = self
        
        scrollView.chartView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        scrollView.addSubview(refreshControl)
        view.addSubview(scrollView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.resizeScrollViewContent()
    }
    
    @objc func refresh() {
        
        print("Refreshing data...")

        let seconds = 4.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.refreshControl.endRefreshing()
        }
    }

}

// MARK: - Chart view delegate

extension CryptoDetailViewController: ChartViewDelegate {

    func chartViewDoubleTapped() {

        let vc = ChartViewController()
        vc.tradingViewChart = TradingViewChart(symbol: crypto.symbol + "USDT", exchange: .binance, theme: .dark)

        vc.modalPresentationStyle = .popover
        
        present(vc, animated: true, completion: nil)
    }
}


// MARK: - Scroll view delegate

extension CryptoDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let delegate = scrollViewDelegate else { return }
        delegate.scrollViewDidScrollVertically(scrollView: scrollView)
    }
    
}


// MARK: - Constraints

extension CryptoDetailViewController {
    
    override func updateViewConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }
}


// MARK: user interface style handling

extension CryptoDetailViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        scrollView.chartView.reloadChart()
    }
}
