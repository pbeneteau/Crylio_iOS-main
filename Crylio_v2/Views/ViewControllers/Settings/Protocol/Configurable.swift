//
//  Configurable.swift
//  QuickTableViewController
//
//  Created by Ben on 30/07/2017.
//  Copyright © 2017 bcylin.


import UIKit

/// Any type that conforms to this protocol is able to take `Row & RowStyle` as the configuration.
public protocol Configurable {
  /// Configure the receiver with an instance that conforms to `Row & RowStyle`.
    func configure(with row: Row & RowStyle, position: SettingsTableViewCellPosition)
}


extension UITableViewCell {

  internal func defaultSetUp(with row: Row & RowStyle) {
    textLabel?.text = row.text
    detailTextLabel?.text = row.detailText?.text

    // Reset the accessory view in case the cell is reused.
    accessoryView = nil
    accessoryType = row.accessoryType

    imageView?.image = row.icon?.image
    imageView?.highlightedImage = row.icon?.highlightedImage
  }

}
