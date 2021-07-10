//
//  TapActionCell.swift
//  QuickTableViewController
//
//  Created by Ben on 03/09/2015.
//  Copyright (c) 2015 bcylin.

import UIKit

/// A `UITableViewCell` subclass with the title text center aligned.
open class TapActionCell: SettingsTableViewCell {
    
    // MARK: - Initializer
    
    /**
     Overrides `UITableViewCell`'s designated initializer.
     
     - parameter style:           Unused. It always uses `UITableViewCellStyle.default`.
     - parameter reuseIdentifier: A string used to identify the cell object if it is to be reused for drawing multiple rows of a table view.
     
     - returns: An initialized `TapActionCell` object.
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
    
    // MARK: UIView
    
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        textLabel?.textColor = tintColor
    }
    
    // MARK: Private Methods
    
    private func setUpAppearance() {
        
        textLabel?.numberOfLines = 0
        textLabel?.textAlignment = .center
        textLabel?.textColor = tintColor
    }

}
