//
//  MarketViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 04/06/2021.
//

import UIKit

class MarketViewController: BaseViewController {
    
    lazy var subtitleLabel = UILabel()
    lazy var marketCapLabel = UILabel()
    lazy var changeLabel = UILabel()
    
    lazy var marketStatsScrollView = MarketStatsScrollView()
    lazy var separationLineView = UIView()
    
    lazy var subMenuView = MarketSubMenu(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    lazy var tableView = UITableView()
    var searchBar = CustomSearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
    var searchActive = false

    var cryptos = [Cryptocurrency]()
    var filteredCryptos = [Cryptocurrency]()

    override func viewDidLoad() {
        super.viewDidLoad()

        subtitleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        marketCapLabel.font = .systemFont(ofSize: 34, weight: .bold)
        changeLabel.font = 	.systemFont(ofSize: 17, weight: .bold)
        
        subtitleLabel.textColor = AppColors.label.secondary
        
        separationLineView.backgroundColor = .label.withAlphaComponent(0.1)
        
        subMenuView.reloadData()
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MarketTableViewCell.self, forCellReuseIdentifier: MarketTableViewCell.reuseId)
        tableView.tableHeaderView = searchBar
        
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorColor = .label.withAlphaComponent(0.15)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 63, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        searchBar.delegate = self

        view.addSubview(subtitleLabel)
        view.addSubview(marketCapLabel)
        view.addSubview(changeLabel)
        view.addSubview(changeLabel)
        view.addSubview(marketStatsScrollView)
        view.addSubview(separationLineView)
        view.addSubview(subMenuView)
        view.addSubview(tableView)
        
        initValues()
        view.setNeedsUpdateConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.setContentOffset(CGPoint(x: 0, y: 44), animated: false) /// hide search bar
        
    }

    private func initValues() {
        
        subtitleLabel.text = "Global Market"
        marketCapLabel.text = "$1.619T"
        changeLabel.setPercentMutableString(value: -13.4, colors: true)
        
        loadCryptos()
    }
    
    func loadCryptos() {
        
        let crypto1: Cryptocurrency = Cryptocurrency(id: 0,
                                                     name: "Bitcoin",
                                                     slug: "bitcoin",
                                                     symbol: "BTC",
                                                     description: "Bitcoin is first.",
                                                     balance: 343492.98,
                                                     amount: 11.2,
                                                     price: 34467.15,
                                                     change: 4.56,
                                                     iconURL: "https://s2.coinmarketcap.com/static/img/coins/128x128/1.png",
                                                     marketStats: CryptoMarketStats(volume24: 115149016927.31, volume24Change: 2.61, marketCap: 625760348347.31, marketCapChange: 2.61, availableSupply: 45425790652.52, availableSupplyChange: 1.5, totalSupply: 100000000000.62))!
        
        let crypto2: Cryptocurrency = Cryptocurrency(id: 1,
                                                     name: "Ripple",
                                                     slug: "ripple",
                                                     symbol: "XRP",
                                                     description: "XRP is second.",
                                                     balance: 34392.62,
                                                     amount: 62923.55,
                                                     price: 1.45,
                                                     change: 12.52,
                                                     iconURL: "https://s2.coinmarketcap.com/static/img/coins/128x128/52.png",
                                                     marketStats: CryptoMarketStats(volume24: 115149016927.31, volume24Change: 2.61, marketCap: 625760348347.31, marketCapChange: 2.61, availableSupply: 45425790652.52, availableSupplyChange: 1.5, totalSupply: 100000000000.62))!
        
        cryptos += [crypto1, crypto2, crypto1, crypto2, crypto1]
        filteredCryptos = cryptos
        
        tableView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        searchBar.layer.borderColor = AppColors.background.primary.cgColor
    }
}


// MARK: - Table view delegate and datasource

extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        if searchActive {
            return filteredCryptos.count
        }
        return cryptos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 67
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: MarketTableViewCell.reuseId, for: indexPath) as? MarketTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MarketTableViewCell.")
        }
        
        if !searchActive {
            cell.configure(crypto: cryptos[indexPath.row])
        } else {
            cell.configure(crypto: filteredCryptos[indexPath.row])
        }
        
        cell.iconImageView.kf.cancelDownloadTask()
        cell.layoutIfNeeded()
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = CryptocurrencyViewController(crypto: cryptos[indexPath.row])
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 25
    }
    
}


// MARK: - Search bar delegate

extension MarketViewController: UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredCryptos = cryptos.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.symbol.localizedCaseInsensitiveContains(searchText)}
        
        if searchText == "" {
            searchActive = false
        } else {
            searchActive = true
        }
        
        tableView.reloadData()
    }
    
}


// MARK: - Constraints

extension MarketViewController {
    
    override func updateViewConstraints() {
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.top.equalTo(90)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.height.equalTo(18)
        }
        
        marketCapLabel.snp.makeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.height.equalTo(39)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.top.equalTo(marketCapLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.height.equalTo(20)
        }
        
        marketStatsScrollView.snp.makeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.top.equalTo(changeLabel.snp.bottom).offset(20)
            make.right.equalToSuperview()
            make.height.equalTo(17)
        }
        
        separationLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(marketStatsScrollView.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
        
        subMenuView.snp.makeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.top.equalTo(separationLineView.snp.bottom).offset(15)
            make.right.equalToSuperview()
            make.height.equalTo(35)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(subMenuView.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
                                
        super.updateViewConstraints()
    }
    
}
