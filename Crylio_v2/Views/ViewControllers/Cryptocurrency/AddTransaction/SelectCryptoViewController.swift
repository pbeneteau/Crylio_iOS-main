//
//  SelectCryptoViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 15/06/2021.
//

import UIKit

protocol SelectCryptoViewControllerDegate: NSObjectProtocol {
    func didSelectCrypto(_ crypto: Cryptocurrency)
}

class SelectCryptoViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    weak var selectionDelegate: SelectCryptoViewControllerDegate!
    
    var cryptos: [Cryptocurrency]!
    var filteredCryptos = [Cryptocurrency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        
        view.backgroundColor = AppColors.background.primary
        
        tableView.register(SelectCryptoTableViewCell.self, forCellReuseIdentifier: SelectCryptoTableViewCell.reuseId)
        tableView.rowHeight = 45
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        tableView.tableHeaderView = searchController.searchBar
        
        filteredCryptos = cryptos
        
        tableView.reloadData()
    }
    
    @objc private func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Table view delagte and datasource

extension SelectCryptoViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredCryptos.count
        }
        return cryptos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: SelectCryptoTableViewCell.reuseId, for: indexPath) as? SelectCryptoTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SelectCryptoTableViewCell.")
        }
        
        var crypto: Cryptocurrency!
        
        if searchController.isActive && searchController.searchBar.text != "" {
            crypto = filteredCryptos[indexPath.row]
        } else {
            crypto = cryptos[indexPath.row]
        }
        
        cell.iconImageView.setImage(from: crypto.iconURL)
        cell.nameLabel.text = crypto.name
        cell.symbolLabel.text = crypto.symbol.uppercased()
        
        cell.iconImageView.kf.cancelDownloadTask()
        cell.layoutIfNeeded()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if let delegate = selectionDelegate {
            if searchController.isActive && searchController.searchBar.text != "" {
                delegate.didSelectCrypto(filteredCryptos[indexPath.row])
            } else {
                delegate.didSelectCrypto(cryptos[indexPath.row])
            }
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
}


// MARK: - Search controller delegate

extension SelectCryptoViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else { return }
        
        filteredCryptos = cryptos.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.symbol.localizedCaseInsensitiveContains(searchText)}
        
        tableView.reloadData()
    }
    
}

