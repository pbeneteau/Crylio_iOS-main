//
//  CryptoHoldingsViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 08/02/2021.
//

import UIKit

class CryptoHoldingsViewController: BaseViewController {

    lazy var scrollView = CryptoHoldingsScrollView()
    
    var refreshControl = UIRefreshControl()

    var blurredHeaderViewAlpha: CGFloat = 0.0
    var scrollViewYOffset: CGFloat = 0.0
    
    weak var scrollViewDelegate: ScrollViewDidScrollDelegate?
    
    var crypto: Cryptocurrency!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        scrollView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        view.addSubview(scrollView)
        scrollView.addSubview(refreshControl)
    }
    
    convenience init(crypto: Cryptocurrency) {
        self.init()
        
        self.crypto = crypto
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


// SCROLL VIEW DELEGATE

extension CryptoHoldingsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewYOffset = scrollView.contentOffset.y
        
        guard let delegate = scrollViewDelegate else { return }
        delegate.scrollViewDidScrollVertically(scrollView: scrollView)
    }
    
}


// CONSTRAINTS

extension CryptoHoldingsViewController {
    
    override func updateViewConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }
    
}
