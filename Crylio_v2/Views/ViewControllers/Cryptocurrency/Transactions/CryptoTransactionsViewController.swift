//
//  CryptoHistoryViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 08/02/2021.
//

import UIKit



struct Transaction {
    
    var asset: String
    var transactionType: TransactionType
    var exchange: String
    var amount: Float
    var amountExecuted: Float
    var time: Date
    var worth: Float
    var status: TransactionStatus
}

enum TransactionType: String {
    
    case marketSell = "Market Sell"
    case marketBuy = "Market Buy"
    case limitSell = "Limit Sell"
    case limitBuy = "Limit Buy"
    case transferIn = "Transfer in"
    case transferOut = "Transfer out"
}

enum TransactionStatus: String {
    
    case filled = "Filled"
    case unfilled = "Unfilled"
    case canceled = "Canceled"
    case transfered = "Transfered"
}

struct TransactionsMonthSection {
    
    var month: Date
    var transactions: [Transaction]
    
    static func group(transactions : [Transaction]) -> [TransactionsMonthSection] {
        
        let groups = Dictionary(grouping: transactions) { (transaction) -> Date in
            return transaction.time.getFirstDayOfMonth()
        }
        return groups.map(TransactionsMonthSection.init(month:transactions:))
    }
    
    func getDateString() -> String {
        
        let date = month
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        return dateFormatter.string(from: date)
    }
}


class CryptoTransactionsViewController: BaseViewController {
    
    
    lazy var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    var refreshControl = UIRefreshControl()
    
    weak var scrollViewDelegate: ScrollViewDidScrollDelegate?
    
    var blurredHeaderViewAlpha: CGFloat = 0.0
    var scrollViewYOffset: CGFloat = 0.0
    
    var crypto: Cryptocurrency!
    
    var sections = [TransactionsMonthSection]()
    var transactions = [Transaction]()
    
    var expandedCells = [IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        
        tableView.estimatedRowHeight = 112
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.sectionHeaderHeight = 50
        
        tableView.register(CryptoTransactionCell.self, forCellReuseIdentifier: CryptoTransactionCell.reuseId)
        tableView.register(TransactionsHeaderView.self, forHeaderFooterViewReuseIdentifier: TransactionsHeaderView.reuseId)
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        tableView.separatorStyle = .none
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        
        data()
    }
    
    convenience init(crypto: Cryptocurrency) {
        self.init()
        
        self.crypto = crypto
    }
    
    private func data() {
        
        let item1 = Transaction(asset: "BTC", transactionType: .marketBuy, exchange: "Binance", amount: 0.48591, amountExecuted: 2.4, time: Date(), worth: 9401.41, status: .filled)
        let item2 = Transaction(asset: "BTC", transactionType: .limitSell, exchange: "Bitfinex", amount: 0.94114, amountExecuted: 2.4, time: Date(), worth: 41491.67, status: .canceled)
        
        var dateComponent = DateComponents()
        
        dateComponent.month = 1
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        
        let item3 = Transaction(asset: "BTC", transactionType: .transferIn, exchange: "Coinbase", amount: 0.24123, amountExecuted: 2.4, time: futureDate!, worth: 5141.10, status: .transfered)
        
        transactions.append(item1)
        transactions.append(item2)
        transactions.append(item3)
        
        sections = TransactionsMonthSection.group(transactions: transactions)
        sections.sort { (lhs, rhs) in lhs.month < rhs.month }
        
        tableView.reloadData()
    }
    
    func updateInsets(menuMaxY: CGFloat) {
        
        tableView.contentInset = UIEdgeInsets(top: menuMaxY, left: 0, bottom: view.frame.height, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: menuMaxY-20, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -menuMaxY)
    }
    
    @objc func refresh() {
        
        print("Refreshing data...")
        
        let seconds = 4.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.refreshControl.endRefreshing()
        }
    }
    
}


// MARK: - Table view delegate and datasource

extension CryptoTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TransactionsHeaderView.reuseId) as! TransactionsHeaderView
        header.date.text = sections[section].getDateString()
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTransactionCell.reuseId, for: indexPath) as? CryptoTransactionCell  else {
            fatalError("The dequeued cell is not an instance of HomeTableViewCell.")
        }
        
        cell.transaction = sections[indexPath.section].transactions[indexPath.row]
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CryptoTransactionCell else { return }
        
        
        if let index = expandedCells.firstIndex(of: indexPath) {
            
            cell.hideDetailView()
            expandedCells.remove(at: index)
        } else {
            cell.showDetailView()
            expandedCells.append(indexPath)
        }
        tableView.performBatchUpdates(nil)
    }
        
    // Add some space after section
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    // Eliminate extra separators below UITableView 
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}


// Mark: - Scroll view delegate

extension CryptoTransactionsViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollViewYOffset = scrollView.contentOffset.y
        
        guard let delegate = scrollViewDelegate else { return }
        delegate.scrollViewDidScrollVertically(scrollView: scrollView)
    }
    
}


// MARK: - Constraints

extension CryptoTransactionsViewController {
    
    override func updateViewConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }
}
