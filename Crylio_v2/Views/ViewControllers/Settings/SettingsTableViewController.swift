//
//  SettingsTableViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 10/07/2021.
//

import UIKit

fileprivate struct SettingsRow {
    
    var title: String?
    var icon: UIImage?
    var isSwitchOn: Bool
    var link: NSURL?
    
    enum RowType {
        case switchRow
        case navigationRow
        case actionRow
        case linkRow
    }
    
}

class SettingsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let debugging = Section(title: nil, rows: [NavigationRow(text: "", detailText: .none)])
    
    /// The layout of sections and rows to display in the table view.
    open var tableContents: [Section] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        view.backgroundColor = AppColors.background.primary
        
        let image: UIImage! = UIImage(named: "binance")
        
        tableContents = [
            Section(title: "Switch", rows: [
                SwitchRow(text: "Setting 1", detailText: .subtitle("Example subtitle"), switchValue: true, icon: .image(image), action: didToggleSwitch()),
                SwitchRow(text: "Setting 2", switchValue: false, icon: .image(image), action: didToggleSwitch())
            ]),
            
            Section(title: "Tap Action", rows: [
                TapActionRow(text: "Tap action", action: showAlert())
            ]),
            
            Section(title: "Navigation", rows: [
                NavigationRow(text: "CellStyle.default", detailText: .none, icon: .image(image)),
                NavigationRow(text: "CellStyle", detailText: .subtitle(".subtitle"), icon: .image(image), accessoryButtonAction: showDetail()),
                NavigationRow(text: "CellStyle", detailText: .value1(".value1"), icon: .image(image), action: showDetail()),
                NavigationRow(text: "CellStyle", detailText: .value2(".value2"))
            ], footer: "UITableViewCellStyle.Value2 hides the image view."),
            
            RadioSection(title: "Radio Buttons", options: [
                OptionRow(text: "Option 1", isSelected: true, action: didToggleSelection()),
                OptionRow(text: "Option 2", isSelected: false, action: didToggleSelection()),
                OptionRow(text: "Option 3", isSelected: false, action: didToggleSelection())
            ], footer: "See RadioSection for more details."),
            
            debugging
        ]
        
        tableView.backgroundColor = .clear
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.separatorStyle = .none
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 60
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.navigationController?.navigationBar.isHidden = false
        tabBarController?.navigationController?.navigationBar.prefersLargeTitles = true
        if let indexPath = tableView.indexPathForSelectedRow, clearsSelectionOnViewWillAppear {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: - Table view data source

extension SettingsTableViewController {
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return tableContents.count
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContents[section].rows.count
    }
    
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableContents[section].title
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableContents[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.cellReuseIdentifier) ?? row.cellType.init(style: row.cellStyle, reuseIdentifier: row.cellReuseIdentifier)
                
        if tableContents[indexPath.section].rows.count == 1 {
            (cell as? Configurable)?.configure(with: row, position: .alone)
        } else if indexPath.row == 0 {
            (cell as? Configurable)?.configure(with: row, position: .top)
        } else if indexPath.row == tableContents[indexPath.section].rows.count - 1 {
            (cell as? Configurable)?.configure(with: row, position: .bottom)
        } else {
            (cell as? Configurable)?.configure(with: row, position: .middle)
        }
        
        cell.defaultSetUp(with: row)
        (cell as? SwitchCell)?.delegate = self
        row.customize?(cell, row)

        return cell
    }
    
    open override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return tableContents[section].footer
    }
    
}

// MARK: - UITableViewDelegate

extension SettingsTableViewController {
    
    open override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return tableContents[indexPath.section].rows[indexPath.row].isSelectable
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = tableContents[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch (section, row) {
        case let (radio as RadioSection, option as OptionRowCompatible):
            let changes: [IndexPath] = radio.toggle(option).map {
                IndexPath(row: $0, section: indexPath.section)
            }
            if changes.isEmpty {
                tableView.deselectRow(at: indexPath, animated: false)
            } else {
                tableView.reloadRows(at: changes, with: .automatic)
            }
            
        case let (_, option as OptionRowCompatible):
            // Allow OptionRow to be used without RadioSection.
            option.isSelected = !option.isSelected
            tableView.reloadData()
            
        case (_, is TapActionRowCompatible):
            tableView.deselectRow(at: indexPath, animated: true)
            // Avoid some unwanted animation when the action also involves table view reload.
            DispatchQueue.main.async {
                row.action?(row)
            }
            
        case let (_, row) where row.isSelectable:
            DispatchQueue.main.async {
                row.action?(row)
            }
            
        default:
            break
        }
    }
    
    public override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        switch tableContents[indexPath.section].rows[indexPath.row] {
        case let row as NavigationRowCompatible:
            DispatchQueue.main.async {
                row.accessoryButtonAction?(row)
            }
        default:
            break
        }
    }
}

// MARK: - Private methods

extension SettingsTableViewController {
    
    private func didToggleSelection() -> (Row) -> Void {
        return { [weak self] in
            if let option = $0 as? OptionRowCompatible {
                let state = "\(option.text) is " + (option.isSelected ? "selected" : "deselected")
                self?.showDebuggingText(state)
            }
        }
    }
    
    private func didToggleSwitch() -> (Row) -> Void {
        return { [weak self] in
            if let row = $0 as? SwitchRowCompatible {
                let state = "\(row.text) = \(row.switchValue)"
                self?.showDebuggingText(state)
            }
        }
    }
    
    private func showAlert() -> (Row) -> Void {
        return { [weak self] _ in
            let alert = UIAlertController(title: "Action Triggered", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showDetail() -> (Row) -> Void {
        return { [weak self] in
            let detail = $0.text + ($0.detailText?.text ?? "")
            let controller = UIViewController()
            controller.view.backgroundColor = .white
            controller.title = detail
            self?.navigationController?.pushViewController(controller, animated: true)
            self?.showDebuggingText(detail + " is selected")
        }
    }
    
    private func showDebuggingText(_ text: String) {
        print(text)
        debugging.rows = [NavigationRow(text: text, detailText: .none)]
        if let section = tableContents.firstIndex(where: { $0 === debugging }) {
            tableView.reloadSections([section], with: .none)
        }
    }
}

extension SettingsTableViewController: SwitchCellDelegate {
    
    // MARK: - SwitchCellDelegate
    open func switchCell(_ cell: SwitchCell, didToggleSwitch isOn: Bool) {
        guard
            let indexPath = tableView.indexPath(for: cell),
            let row = tableContents[indexPath.section].rows[indexPath.row] as? SwitchRowCompatible
        else {
            return
        }
        row.switchValue = isOn
    }
}

