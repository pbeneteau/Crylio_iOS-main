//
//  SwitchCell.swift
//  QuickTableViewController
//
//  Created by Ben on 03/09/2015.
//  Copyright (c) 2015 bcylin.

import UIKit

public protocol SwitchCellDelegate: AnyObject {
    
    /// Tells the delegate that the switch control is toggled.
    func switchCell(_ cell: SwitchCell, didToggleSwitch isOn: Bool)
}

/// A `UITableViewCell` subclass that shows a `UISwitch` as the `accessoryView`.
open class SwitchCell: SettingsTableViewCell {
    
    public private(set) lazy var switchControl: UISwitch = {
        let control = UISwitch()
        control.addTarget(self, action: #selector(SwitchCell.didToggleSwitch(_:)), for: .valueChanged)
        return control
    }()
    
    open weak var delegate: SwitchCellDelegate?
    
    // MARK: - Initializer
    
    /**
     Overrides `UITableViewCell`'s designated initializer.
     
     - parameter style:           A constant indicating a cell style.
     - parameter reuseIdentifier: A string used to identify the cell object if it is to be reused for drawing multiple rows of a table view.
     
     - returns: An initialized `SwitchCell` object.
     */
    public required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setUpAppearance()
    }
    
    /**
     Overrides the designated initializer that returns an object initialized from data in a given unarchiver.
     
     - parameter aDecoder: An unarchiver object.
     
     - returns: `self`, initialized using the data in decoder.
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpAppearance()
    }
    
    // MARK: - Configurable
    
    /// Set up the switch control (iOS).
    open override func configure(with row: Row & RowStyle, position: SettingsTableViewCellPosition) {
        super.configure(with: row, position: position)
                
        if let row = row as? SwitchRowCompatible {
            switchControl.isOn = row.switchValue
        }
        accessoryView = switchControl
    }
    
    // MARK: - Private
    
    @objc
    private func didToggleSwitch(_ sender: UISwitch) {
        delegate?.switchCell(self, didToggleSwitch: sender.isOn)
    }
    
    private func setUpAppearance() {
        textLabel?.numberOfLines = 0
        detailTextLabel?.numberOfLines = 0
    }
    
}
