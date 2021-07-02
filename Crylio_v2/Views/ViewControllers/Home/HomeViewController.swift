//
//  ViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 27/01/2021.
//

import UIKit
import SnapKit


class HomeViewController: BaseViewController {
    
    lazy var blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    lazy var header = HomeHeaderView()
    lazy var gainersLosersLabel = UILabel()
    lazy var gainersLosersCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var subMenuView = MarketSubMenu(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    lazy var cryptosTableView = UITableView()
    var searchBar = CustomSearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
    
    var searchActive = false
    var viewAppeard = false
    var savedYOffset: CGFloat!
    
    var gainersLosers = [Cryptocurrency]()
    var cryptos = [Cryptocurrency]()
    var filteredCryptos = [Cryptocurrency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurredView.backgroundColor = AppColors.blur
        blurredView.alpha = 0
        
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader(_:))))
        
        gainersLosersLabel.font = .systemFont(ofSize: 20, weight: .bold)
        gainersLosersLabel.text = "Gainers & Losers"
        
        gainersLosersCollectionView.delegate = self
        gainersLosersCollectionView.dataSource = self
        gainersLosersCollectionView.register(GainersLosersCollectionViewCell.self, forCellWithReuseIdentifier: GainersLosersCollectionViewCell.reuseId)
        gainersLosersCollectionView.backgroundColor = .clear
        gainersLosersCollectionView.contentInset = UIEdgeInsets(top: 0, left: SAFE_AREA_MARGIN, bottom: 0, right: SAFE_AREA_MARGIN)
        gainersLosersCollectionView.layer.masksToBounds = false
        gainersLosersCollectionView.showsHorizontalScrollIndicator = false
        
        if let layout = gainersLosersCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        cryptosTableView.delegate = self
        cryptosTableView.dataSource = self
        cryptosTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseId)
        cryptosTableView.backgroundColor = .clear
        cryptosTableView.separatorStyle = .none
        cryptosTableView.keyboardDismissMode = .onDrag
        cryptosTableView.tableHeaderView = searchBar
        cryptosTableView.contentInset = UIEdgeInsets(top: 505, left: 0, bottom: 100, right: 0)
        cryptosTableView.contentOffset.y = -cryptosTableView.contentInset.top
        cryptosTableView.contentInsetAdjustmentBehavior = .never
        cryptosTableView.showsVerticalScrollIndicator = false
        
        searchBar.delegate = self
        searchBar.backgroundColor = .clear
        searchBar.tintColor = .clear
        
        view.addSubview(cryptosTableView)
        view.addSubview(gainersLosersLabel)
        view.addSubview(gainersLosersCollectionView)
        view.addSubview(blurredView)
        view.addSubview(subMenuView)
        view.addSubview(header)
        
        loadCryptos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func loadCryptos() {
        
        cryptos += [crypto1, crypto2, crypto1, crypto2, crypto1, crypto2, crypto1, crypto2, crypto1, crypto2, crypto1]
        filteredCryptos = cryptos
        gainersLosers += [crypto1, crypto2, crypto1]
        
        sortGainersLosers()
        
        cryptosTableView.reloadData()
        gainersLosersCollectionView.reloadData()
    }
    
    private func sortGainersLosers() {
        
        gainersLosers.sort { a, b in
            return a.change > b.change
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewAppeard = true
        //cryptosTableView.setContentOffset(CGPoint(x: 0, y: -512), animated: false)
    }
    
    private func setCryptosTableViewSearchOffset() {
        
        if searchActive {
            cryptosTableView.setContentOffset(CGPoint(x: 0, y: 180), animated: true)
        } else {
            searchBar.endEditing(true)
            cryptosTableView.setContentOffset(CGPoint(x: 0, y: savedYOffset ?? cryptosTableView.contentInset.top), animated: true)
        }
    }
    
}


// MARK: - Collection view delegate and datasource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gainersLosers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = gainersLosersCollectionView.dequeueReusableCell(withReuseIdentifier: GainersLosersCollectionViewCell.reuseId, for: indexPath) as? GainersLosersCollectionViewCell  else {
            fatalError("The dequeued cell is not an instance of gainersLosersCollectionView.")
        }
        
        let chartData: [Double] = (1...40).map {_ in Double.random(in: 300...600)}
        let data = GainersLosersCollectionViewCellModel(
            iconUrl: gainersLosers[indexPath.row].iconURL,
            symbol: gainersLosers[indexPath.row].symbol,
            name: gainersLosers[indexPath.row].name,
            price: gainersLosers[indexPath.row].price,
            change: gainersLosers[indexPath.row].change,
            chartData: chartData)
        
        cell.configure(with: data)
        cell.iconImageView.kf.cancelDownloadTask()
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
}


// MARK: - Gestures delegate

extension HomeViewController {
    
    @objc func didTapHeader(_ sender: UITapGestureRecognizer) {
        
        let controller = PortfolioDetailViewController()
        controller.title = "Main Portfolio"
        
        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - Table view delegate and datasource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive == true && searchBar.text != "" {
            return filteredCryptos.count
        }
        return cryptos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.cryptosTableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseId, for: indexPath) as? HomeTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HomeTableViewCell.")
        }
        
        if searchActive == true && searchBar.text != "" {
            cell.crypto = filteredCryptos[indexPath.row]
        } else {
            cell.crypto = cryptos[indexPath.row]
        }
        
        cell.iconImageView.kf.cancelDownloadTask()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = CryptocurrencyViewController(crypto: cryptos[indexPath.row])
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if viewAppeard {
            if scrollView.isKind(of: UITableView.self) {
                savedYOffset = scrollView.contentOffset.y
                let y = scrollView.contentOffset.y + scrollView.contentInset.top
                updateContentOffset(y)
            }
        }
    }
    
    private func updateContentOffset(_ yOffset: CGFloat) {
        
        header.snp.updateConstraints { make in
            make.height.equalTo(min(max(150-yOffset, 50), 150))
        }
        
        gainersLosersLabel.transform = CGAffineTransform(translationX: 0, y: -yOffset)
        gainersLosersCollectionView.transform = CGAffineTransform(translationX: 0, y: -yOffset)
        
        subMenuView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.top.equalTo(max(gainersLosersCollectionView.frame.maxY+30, header.frame.maxY + 20)).priority(999)
            make.height.equalTo(35)
        }
        
        header.updateLayout(min(1, (header.frame.height-50)/100))
        blurredView.alpha = 1 - (subMenuView.frame.maxY-5-blurredView.frame.maxY)/30
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
        cryptosTableView.reloadData()
    }
    
    func filterIsNotActive() {
        
        searchActive = false
        cryptosTableView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        searchBar.layer.borderColor = AppColors.background.primary.cgColor
    }
}


// MARK: - Search bar delegate

extension HomeViewController: UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        cryptosTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredCryptos = cryptos.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.symbol.localizedCaseInsensitiveContains(searchText)}
        
        if searchText == "" {
            searchActive = false
        } else {
            searchActive = true
        }
        cryptosTableView.reloadData()
    }
    
}


// MARK: - Constraints

extension HomeViewController {
    
    override func updateViewConstraints() {
        
        cryptosTableView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        blurredView.snp.remakeConstraints { make in
            make.left.width.top.equalToSuperview()
            make.height.equalTo(170)
        }
        
        header.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.top.equalTo(60)
            make.height.equalTo(150)
        }
        
        gainersLosersLabel.snp.remakeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.height.equalTo(22)
            make.top.equalTo(60 + 150 + 30)
        }
        
        gainersLosersCollectionView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
            make.top.equalTo(gainersLosersLabel.snp.bottom).offset(15)
        }
        
        subMenuView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.top.equalTo(460)
            make.height.equalTo(35)
        }
        
        super.updateViewConstraints()
    }
}
