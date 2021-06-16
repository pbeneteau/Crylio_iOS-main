//
//  Test2ViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 30/01/2021.
//

import UIKit
import SnapKit
import PagingKit


protocol ScrollViewDidScrollDelegate: AnyObject {
    func scrollViewDidScrollVertically(scrollView: UIScrollView)
}

class CryptocurrencyViewController: BaseViewController, UIGestureRecognizerDelegate, UITableViewDelegate {
    
    lazy var navigationTopBar = NavigationTopBarView()
    lazy var header = CryptoHeaderView()
    lazy var menu = CryptoMenuView(items: ["Details", "Holding", "News", "Transactions"])
    lazy var addTransactionButton = RoundShadowView()

    lazy var menuScrollView: UIScrollView = {
        
        let view = UIScrollView()
        view.delegate = self
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.tag = 10
        view.backgroundColor = .clear
        view.bounces = false
        view.contentSize = CGSize(width: 1, height: 1)
        
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    // MARK: ViewControllers
    lazy var detailVC  = CryptoDetailViewController()
    lazy var holdingsVC = CryptoHoldingsViewController()
    lazy var ordersVC = CryptoNewsFeedViewController()
    lazy var transactionsVC = CryptoTransactionsViewController()
    
    var viewDidLayoutFirstTime = true
    
    var displayedVCTag = 0
    
    var crypto: Cryptocurrency!
    
    convenience init(crypto: Cryptocurrency) {
        self.init()
        
        self.crypto = crypto
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailVC.crypto = self.crypto
        holdingsVC.crypto = self.crypto
        transactionsVC.crypto = self.crypto
        
        header.crypto = crypto
        
        addChild(detailVC)
        detailVC.didMove(toParent: self)
        
        addChild(holdingsVC)
        holdingsVC.didMove(toParent: self)
        
        addChild(ordersVC)
        ordersVC.didMove(toParent: self)
        
        addChild(transactionsVC)
        transactionsVC.didMove(toParent: self)
        
        navigationTopBar.titleLabel.text = crypto.name
        navigationTopBar.changeLabel.setPercentMutableString(value: crypto.change, colors: true)
        
        menuScrollView.contentSize.width = view.frame.size.width * 4
        menuScrollView.contentSize.height = 1
                
        detailVC.scrollView.tag = 0
        detailVC.scrollViewDelegate = self
        
        holdingsVC.scrollView.tag = 1
        holdingsVC.scrollViewDelegate = self
        
        ordersVC.tableView.tag = 2
        ordersVC.scrollViewDelegate = self
        
        transactionsVC.tableView.tag = 3
        transactionsVC.scrollViewDelegate = self
        
        menu.delegate = self
        navigationTopBar.delegate = self
        detailVC.scrollView.balanceView.delegate = self
        
        detailVC.view.tag = 0
        holdingsVC.view.tag = 1
        ordersVC.view.tag = 2
        transactionsVC.view.tag = 3
        
        menuScrollView.addSubview(detailVC.view)
        menuScrollView.addSubview(holdingsVC.view)
        menuScrollView.addSubview(ordersVC.view)
        menuScrollView.addSubview(transactionsVC.view)
        
        addTransactionButton.layer.cornerRadius = 30
        addTransactionButton.backgroundColor = .systemBlue
        addTransactionButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addButtonAction(_:))))
        addTransactionButton.layer.shadowOpacity = 0.13
        
        view.addSubview(menuScrollView)
        view.addSubview(header)
        view.addSubview(navigationTopBar)
        view.addSubview(menu)
        view.addSubview(addTransactionButton)

        view.setNeedsUpdateConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        menu.resizeScrollViewContent()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
}


// MARK: - Scroll views delegate

extension CryptocurrencyViewController: ScrollViewDidScrollDelegate, UIScrollViewDelegate {
    
    func scrollViewDidScrollVertically(scrollView: UIScrollView) {
                
        let yOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        
        if scrollView.tag == displayedVCTag {
                                    
            updateHeader(yOffset: yOffset)
            updateOtherScrollViewsOffset(yOffset: scrollView.contentOffset.y)
        }
    }
    
}

// MARK: - Menu manager

extension CryptocurrencyViewController {
    
    func updateOtherScrollViewsOffset(yOffset: CGFloat) {
                
        let newOffset = min(-131, yOffset)

        if displayedVCTag != 0 {
            if detailVC.scrollView.contentOffset.y <= -131 || menu.frame.maxY > 131 {
                detailVC.scrollView.contentOffset.y = newOffset
                detailVC.blurredHeaderViewAlpha = 0
            }
        }
        if displayedVCTag != 1 {
            if holdingsVC.scrollView.contentOffset.y <= -131 || menu.frame.maxY > 131 {
                holdingsVC.scrollView.contentOffset.y = newOffset
                holdingsVC.blurredHeaderViewAlpha = 0
            }
            
        }
        if displayedVCTag != 2 {
            if ordersVC.tableView.contentOffset.y <= -131 || menu.frame.maxY > 131 {
                ordersVC.tableView.contentOffset.y = newOffset
                ordersVC.blurredHeaderViewAlpha = 0
            }
        }
        if displayedVCTag != 3 {
            if transactionsVC.tableView.contentOffset.y <= -131 || menu.frame.maxY > 131 {
                transactionsVC.tableView.contentOffset.y = newOffset
                transactionsVC.blurredHeaderViewAlpha = 0
            }
        }
    }
    
    func updateHeader(yOffset: CGFloat) {
                        
        header.transform = CGAffineTransform(translationX: 0, y: min(0, -yOffset))
        
        menu.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
            make.top.equalTo(max(navigationTopBar.topBar.frame.maxY, header.frame.maxY))
        }
                    
        navigationTopBar.blurredView.alpha = min(1, 2 - header.frame.maxY/menu.frame.minY*2)
        
        saveBlurredViewAlpha(alpha: navigationTopBar.blurredView.alpha)
        
        if max(navigationTopBar.topBar.frame.maxY, header.frame.maxY) == navigationTopBar.topBar.frame.maxY {
            
            navigationTopBar.topBar.alpha = 0
            header.alpha = 0
            
        } else {
            navigationTopBar.blurredView.alpha = 0
            saveBlurredViewAlpha(alpha: 0)
            
            navigationTopBar.topBar.alpha = 1
            header.alpha = 1
        }
        
        if header.nameLabel.frame.maxY/1.5 + header.frame.minY < navigationTopBar.topBar.frame.maxY {
            navigationTopBar.showTitle()
        } else {
            navigationTopBar.hideTitle()
        }
        
    }
    
    func saveBlurredViewAlpha(alpha: CGFloat) {
        
        switch displayedVCTag {
        case 0:
            detailVC.blurredHeaderViewAlpha = alpha
        case 1:
            holdingsVC.blurredHeaderViewAlpha = alpha
        case 2:
            ordersVC.blurredHeaderViewAlpha = alpha
        case 3:
            transactionsVC.blurredHeaderViewAlpha = alpha
        default:
            return
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let xOffset = scrollView.contentOffset.x
        
        switch xOffset {
        case 0...view.frame.width/2-1:
            displayedVCTag = 0
            menu.setSelectedButton(index: displayedVCTag)
        case view.frame.width/2...view.frame.width*1.5-1:
            displayedVCTag = 1
            menu.setSelectedButton(index: displayedVCTag)
        case view.frame.width*1.5...view.frame.width*2.5-1:
            displayedVCTag = 2
            menu.setSelectedButton(index: displayedVCTag)
        case view.frame.width*2.5...view.frame.width*3:
            displayedVCTag = 3
            menu.setSelectedButton(index: displayedVCTag)
        default:
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.updateHeaderAlpha()
        })
    }
    
    func updateHeaderAlpha() {
        
        switch displayedVCTag {
        case 0:
            navigationTopBar.blurredView.alpha = detailVC.blurredHeaderViewAlpha
        case 1:
            navigationTopBar.blurredView.alpha = holdingsVC.blurredHeaderViewAlpha
        case 2:
            navigationTopBar.blurredView.alpha = ordersVC.blurredHeaderViewAlpha
        case 3:
            navigationTopBar.blurredView.alpha = transactionsVC.blurredHeaderViewAlpha
        default:
            return
        }
    }
    
}


// MARK: - Other protocols

extension CryptocurrencyViewController: HorizontalMenuProtocol, CryptoDetailBalanceDelegate, NavigationTopBarDelegate, UIPopoverPresentationControllerDelegate {

    func menuButtonTapped(sender: UIButton!) {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .curveEaseOut]) {
            self.menuScrollView.contentOffset = CGPoint(x: Int(self.view.bounds.width) * sender.tag, y: 0)
            self.view.layoutIfNeeded()
        }
    }
    
    internal func backButtonAction() {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func addButtonAction(_ sender: UIView) {
        
        print("adding transaction...")
                
        let popoverVC = AddTransactionViewController()
        popoverVC.title = crypto.name
        popoverVC.crypto = crypto
        popoverVC.popoverPresentationController?.sourceView = self.view
        popoverVC.popoverPresentationController?.permittedArrowDirections = .up
        popoverVC.popoverPresentationController?.delegate = self
        
        let navVC = UINavigationController(rootViewController: popoverVC)
    
        navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    func CryptoDetailBalanceTouched() {
        
        menuScrollView.setContentOffset(CGPoint(x: view.frame.width, y: 0), animated: true)
    }
    
}


// MARK: - Constraints

extension CryptocurrencyViewController {
    
    override func updateViewConstraints() {
        
        navigationTopBar.snp.makeConstraints { make in
            make.left.width.top.equalToSuperview()
            make.height.equalTo(136)
        }
        
        header.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navigationTopBar.topBar.snp.bottom)
            make.height.equalTo(95)
        }
        
        menu.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
            make.top.equalTo(header.snp.bottom)
        }
        
        menuScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        detailVC.view.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(view)
            make.width.equalTo(view)
        }
        
        holdingsVC.view.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(detailVC.view.snp.right)
            make.top.equalToSuperview()
            make.bottom.equalTo(view)
            make.width.equalTo(view)
        }
        
        ordersVC.view.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(holdingsVC.view.snp.right)
            make.top.equalToSuperview()
            make.bottom.equalTo(view)
            make.width.equalTo(view)
        }
        
        transactionsVC.view.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(ordersVC.view.snp.right)
            make.bottom.equalTo(view)
            make.top.equalToSuperview()
            make.width.equalTo(view)
        }
        
        addTransactionButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.bottom.equalToSuperview().inset(80)
            make.width.height.equalTo(60)
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if viewDidLayoutFirstTime {
            
            viewDidLayoutFirstTime = false
            
            detailVC.scrollView.updateInsets(menuMaxY: menu.frame.maxY)
            holdingsVC.scrollView.updateInsets(menuMaxY: menu.frame.maxY)
            ordersVC.updateInsets(menuMaxY: menu.frame.maxY)
            transactionsVC.updateInsets(menuMaxY: menu.frame.maxY)
            
        }
    }
    
}

extension UIScrollView {

  var minContentOffset: CGPoint {
    return CGPoint(
      x: -contentInset.left,
      y: -contentInset.top)
  }

  var maxContentOffset: CGPoint {
    return CGPoint(
      x: contentSize.width - bounds.width + contentInset.right,
      y: contentSize.height - bounds.height + contentInset.bottom)
  }

  func scrollToMinContentOffset(animated: Bool) {
    setContentOffset(minContentOffset, animated: animated)
  }

  func scrollToMaxContentOffset(animated: Bool) {
    setContentOffset(maxContentOffset, animated: animated)
  }
}


