//
//  ViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 27/01/2021.
//

import UIKit
import SnapKit


class HomeViewController: BaseViewController {
        
    lazy var header = UIView()
    lazy var filterMenuView = FilterMenuView()
    lazy var tableView = UITableView()
    var searchBar = CustomSearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))

    var searchActive = false
    
    var offsetSet = false
    
    lazy var portfolio = UILabel()
    lazy var walletBalance = UILabel()
    lazy var balanceChange = UILabel()
    lazy var balanceChangeFiat = UILabel()
    
    var cryptos = [Cryptocurrency]()
    var filteredCryptos = [Cryptocurrency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.translatesAutoresizingMaskIntoConstraints = false
        
        header.backgroundColor = .lightGray
        
        filterMenuView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseId)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.tableHeaderView = searchBar

        searchBar.delegate = self
                        
        view.addSubview(header)
        view.addSubview(filterMenuView)
        view.addSubview(tableView)
        
        loadCryptos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.setContentOffset(CGPoint(x: 0, y: 44), animated: false) /// hide search bar
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
        
        tableView.reloadData()
    }
    
}


// MARK: - Table view delegate and datasource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
            return filteredCryptos.count
        }
        return cryptos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseId, for: indexPath) as? HomeTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HomeTableViewCell.")
        }
        
        if !searchActive {
            cell.crypto = cryptos[indexPath.row]
        } else {
            cell.crypto = filteredCryptos[indexPath.row]
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


// MARK: - Filter delegate

extension HomeViewController: AssetsFilterDelegate {
    
    func filterDidChanged(_ sender: RoundCornersButton, order: FilterOrderingMode) {
                
        switch sender.tag {
        case 0:
            /// name
            filteredCryptos = cryptos.sorted { ($0.name >= $1.name) ? order == .ascending: ($0.name <= $1.name)}
        case 1:
            /// holdings
            filteredCryptos = cryptos.sorted { ($0.balance >= $1.balance) ? order == .ascending: ($0.balance <= $1.balance) }
        case 2:
            /// change
            filteredCryptos = cryptos.sorted { ($0.change >= $1.change) ? order == .ascending: ($0.change <= $1.change) }
        default:
            filteredCryptos = cryptos
        }
                
        searchActive = true
        tableView.reloadData()
    }
    
    func filterIsNotActive() {
        
        searchActive = false
        tableView.reloadData()
    }
    
}


// MARK: - Search bar delegate

extension HomeViewController: UISearchBarDelegate {
    
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

extension HomeViewController {
    
    override func updateViewConstraints() {
        
        header.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.top.equalToSuperview().offset(60)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.height.equalTo(180)
        }
        
        filterMenuView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.top.equalTo(header.snp.bottom).offset(30)
            make.height.equalTo(30)
        }
                
        tableView.snp.makeConstraints { make in
            make.top.equalTo(filterMenuView.snp.bottom).offset(16)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }
}
