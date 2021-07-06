//
//  ViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 27/01/2021.
//

import UIKit
import SnapKit


protocol HomeViewControllerDelegate: NSObjectProtocol {
    func searchDidBegin()
    func searchDidEnd()
}

protocol HomeViewControllerTableViewHeaderViewDelegate: NSObjectProtocol {
    func didTapHeader(_ sender: UITapGestureRecognizer)
    func didTapCollectionViewCell()
}

class HomeViewController: UITableViewController {
    
    lazy var assetsLabel = UILabel()
    lazy var subMenuView = MarketSubMenu(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var headerHeight: CGFloat = 0
        
    var cryptos = [Cryptocurrency]()
    var filteredCryptos = [Cryptocurrency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.background.primary
                        
        tabBarController?.title = "Home"
                
        let settingsIcon = UIImage(named: "mainSettingsIcon")?.withRenderingMode(.alwaysTemplate)
        let portfoliosIcon = UIImage(named: "portfoliosIcon")?.withRenderingMode(.alwaysTemplate)
        
        let settingsNavigationItem = UIBarButtonItem(image: settingsIcon, style: .plain, target: self, action: #selector(didTapSettingsButton(_:)))
        let portfoliosNavigationItem = UIBarButtonItem(image: portfoliosIcon, style: .plain, target: self, action: #selector(didTapPortfoliosButton(_:)))
        
        settingsNavigationItem.tintColor = AppColors.label.primary
        portfoliosNavigationItem.tintColor = AppColors.label.primary
                        
        tabBarController?.navigationItem.rightBarButtonItems = [settingsNavigationItem, portfoliosNavigationItem]
        tabBarController?.navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        assetsLabel.font = .systemFont(ofSize: 20, weight: .bold)
        assetsLabel.text = "Assets"
            
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseId)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 86
        tableView.sectionHeaderHeight = UITableView.automaticDimension
                
        view.addSubview(assetsLabel)
        view.addSubview(subMenuView)
        
        loadCryptos()
    }
    
    func loadCryptos() {
        
        cryptos += [crypto1, crypto2, crypto1, crypto2, crypto1, crypto2, crypto1, crypto2, crypto1, crypto2, crypto1]
        filteredCryptos = cryptos
                
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.navigationController?.navigationBar.isHidden = false
        tabBarController?.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func didTapPortfoliosButton(_ sender: UIButton) {
        
 
    }
    
    @objc func didTapSettingsButton(_ sender: UIButton) {
        
    }
    
}


// MARK: - Table view delegate and datasource

extension HomeViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 { return 0 }
        
        if isSearching() {
            return filteredCryptos.count
        }
        return cryptos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseId, for: indexPath) as? HomeTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HomeTableViewCell.")
        }
                
        if isSearching() {
            cell.crypto = filteredCryptos[indexPath.row]
        } else {
            cell.crypto = cryptos[indexPath.row]
        }
        
        cell.iconImageView.kf.cancelDownloadTask()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = CryptocurrencyViewController(crypto: cryptos[indexPath.row])
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let tableViewHeader = HomeViewControllerTableViewHeaderView()
            tableViewHeader.delegate = self
            return tableViewHeader
        } else if section == 1 {
            let headerView = HomeViewControllerTableViewAssetsHeaderView()
            return headerView
        }
        return nil
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
        
        tableView.reloadData()
    }
    
    func filterIsNotActive() {
        
        tableView.reloadData()
    }
    
}


// MARK: - Search bar delegate

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
     }
    
    private func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isSearching() -> Bool {
        return searchController.isActive && !isSearchBarEmpty()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        filteredCryptos = cryptos.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.symbol.localizedCaseInsensitiveContains(searchText)}
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        headerHeight = tableView.sectionHeaderHeight
        
        if let header = tableView.headerView(forSection: 0) as? HomeViewControllerTableViewHeaderView {
            header.hide(animated: true)
        }
        tableView.beginUpdates()
        tableView.sectionHeaderHeight = 0
        tableView.endUpdates()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let header = tableView.headerView(forSection: 0) as? HomeViewControllerTableViewHeaderView {
            header.show(animated: true)
        }
        tableView.beginUpdates()
        tableView.sectionHeaderHeight = headerHeight
        tableView.endUpdates()
        tableView.layoutSubviews()
    }
    
}


// MARK: - Header delegates

extension HomeViewController: HomeViewControllerTableViewHeaderViewDelegate {
  
    
    func didTapHeader(_ sender: UITapGestureRecognizer) {
        
        let controller = PortfolioDetailViewController()
        controller.title = "Main Portfolio"
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapCollectionViewCell() {
        
        
    }
    
    
}


// MARK: - Constraints

extension HomeViewController {
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
    }
}

class HomeViewControllerTableViewHeaderView: UITableViewHeaderFooterView {
    
    lazy var headerView = HomeHeaderView()

    lazy var gainersLosersLabel = UILabel()
    lazy var gainersLosersCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    weak var delegate: HomeViewControllerTableViewHeaderViewDelegate!
    
    var gainersLosers = [Cryptocurrency]()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
                
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader(_:))))

        gainersLosersLabel.font = .systemFont(ofSize: 15, weight: .bold)
        gainersLosersLabel.text = "Gainers & Losers"
        gainersLosersLabel.textColor = AppColors.label.secondary
        
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
        
        gainersLosers += [crypto1, crypto2, crypto1]
        sortGainersLosers()
        gainersLosersCollectionView.reloadData()
        
        contentView.addSubview(gainersLosersLabel)
        contentView.addSubview(gainersLosersCollectionView)
        contentView.addSubview(headerView)
        
        contentView.setNeedsUpdateConstraints()
    }
    
    private func sortGainersLosers() {
        
        gainersLosers.sort { a, b in
            return a.change > b.change
        }
    }
    
    func hide(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentView.alpha = 0
            })
        } else {
            contentView.alpha = 0
        }
    }
    
    func show(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentView.alpha = 1
            })
        } else {
            contentView.alpha = 1
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()

        headerView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.width.equalTo(UIScreen.main.bounds.width-SAFE_AREA_MARGIN*2)
            make.top.equalToSuperview()
        }
        
        gainersLosersLabel.snp.remakeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.height.equalTo(18)
        }
        
        gainersLosersCollectionView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
            make.top.equalTo(gainersLosersLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().priority(999)
            make.height.equalTo(150).priority(999)
        }
    }
    
}


// MARK: - Collection view delegate and datasource

extension HomeViewControllerTableViewHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        
        let width = (UIScreen.main.bounds.width - SAFE_AREA_MARGIN*2-10)/2
        return CGSize(width: width, height: 150)
    }
    
}


// MARK: - Gestures delegate

extension HomeViewControllerTableViewHeaderView {
    
    @objc func didTapHeader(_ sender: UITapGestureRecognizer) {
        
        if let delegate = delegate {
            delegate.didTapHeader(sender)
        }
    }
}

class HomeViewControllerTableViewAssetsHeaderView: UITableViewHeaderFooterView {
    
    lazy var label = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        label.text = "Assets"
        label.textColor = AppColors.label.secondary
        label.font = .systemFont(ofSize: 16, weight: .bold)
        
        contentView.addSubview(label)
        
        contentView.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()

        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.width.equalTo(UIScreen.main.bounds.width-SAFE_AREA_MARGIN*2)
            make.top.equalToSuperview().offset(10).priority(999)
            make.height.equalTo(18).priority(999)
            make.bottom.equalToSuperview().priority(999)
        }
    }
}
