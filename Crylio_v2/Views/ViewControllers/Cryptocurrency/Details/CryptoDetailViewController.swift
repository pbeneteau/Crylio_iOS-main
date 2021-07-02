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
                
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        scrollView.chartView.delegate = self
        
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

extension CryptoDetailViewController: CryptoDetailChartViewDelegate {

    func didTapPairButton() {
        
        print("selecting trading pair...")
        
        let controller = SelectionViewController()
        controller.title = "Select Trading Pair"
        controller.items = [crypto1, crypto2, crypto1, crypto2, crypto1]
        controller.selectionDelegate = self
        
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func didTapExchangeButton() {
        
        print("selecting exchange...")
        
        let controller = SelectionViewController()
        controller.title = "Select Exchange"
        controller.items = [Exchange(name: "Binance", iconURL: ""),
                            Exchange(name: "Bitfinex", iconURL: ""),
                            Exchange(name: "Coinbase", iconURL: "")]
        controller.selectionDelegate = self
        
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func didTapFullScreenButton() {
        
        print("opening fullscreen chart view...")
        
        let controller = ChartViewController()
        controller.title = "Chart"

        controller.tradingviewChart = TradingviewChart(type: .big, symbol: crypto.symbol + "USDT", exchange: .binance, theme: traitCollection.userInterfaceStyle == .dark ? .dark: .light)

        navigationController?.present(controller, animated: true, completion: nil)
    }
    
}


// MARK: - Trading pair selection delegate

extension CryptoDetailViewController: SelectionViewControllerDelegate {
    
    func didSelectItem(_ item: Any) {
        
        if let crypto = item as? Cryptocurrency {
            print("did select", crypto.name, "as a trading pair")
            scrollView.chartView.pairButton.setTitle(crypto.symbol, for: UIControl.State.normal)
        }
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
        
        scrollView.chartView.tradingviewChartView.reloadChart()
    }
}
