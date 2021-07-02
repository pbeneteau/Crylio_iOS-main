//
//  SelectCryptoViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 15/06/2021.
//

import UIKit

protocol SelectionViewControllerDelegate: NSObjectProtocol {
    func didSelectItem(_ item: Any)
}

class SelectionViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    weak var selectionDelegate: SelectionViewControllerDelegate!
    
    var items: [Any]!
    var filteredItems = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        
        view.backgroundColor = AppColors.background.primary
        
        tableView.register(SelectionTableViewCell.self, forCellReuseIdentifier: SelectionTableViewCell.reuseId)
        tableView.rowHeight = 55
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        tableView.tableHeaderView = searchController.searchBar
        
        filteredItems = items
        
        tableView.reloadData()
    }
    
    @objc private func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Table view delagte and datasource

extension SelectionViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredItems.count
        }
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: SelectionTableViewCell.reuseId, for: indexPath) as? SelectionTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SelectCryptoTableViewCell.")
        }
        
        var item: Any!
        
        if searchController.isActive && searchController.searchBar.text != "" {
            item = filteredItems[indexPath.row]
        } else {
            item = items[indexPath.row]
        }
        
        if let crypto = item as? Cryptocurrency {
            cell.iconImageView.setImage(from: crypto.iconURL)
            cell.titleLabel.text = crypto.name
            cell.descriptionLabel.text = crypto.symbol.uppercased()
        }
        
        if let exchange = item as? Exchange {
            cell.iconImageView.setImage(from: exchange.iconURL)
            cell.titleLabel.text = exchange.name
        }
        
        cell.iconImageView.kf.cancelDownloadTask()
        cell.layoutIfNeeded()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if let delegate = selectionDelegate {
            if searchController.isActive && searchController.searchBar.text != "" {
                delegate.didSelectItem(filteredItems[indexPath.row])
            } else {
                delegate.didSelectItem(items[indexPath.row])
            }
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
}


// MARK: - Search controller delegate

extension SelectionViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else { return }
        
        if let cryptos = items as? [Cryptocurrency] {
            filteredItems = cryptos.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.symbol.localizedCaseInsensitiveContains(searchText) }
        }
        
        if let exchanges = items as? [Exchange] {
            filteredItems = exchanges.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
            
        tableView.reloadData()
    }
    
}

