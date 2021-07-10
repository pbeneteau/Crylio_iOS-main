//
//  NavigationRow.swift
//  QuickTableViewController
//
//  Created by Ben on 01/09/2015.
//  Copyright (c) 2015 bcylin.

import UIKit

/// A class that represents a row that triggers certain navigation when selected.
open class NavigationRow<T: SettingsTableViewCell>: NavigationRowCompatible, Equatable {

  // MARK: - Initializer

  /// Designated initializer on iOS. Returns a `NavigationRow` with a text and a detail text.
  /// The icon, customization, action and accessory button action closures are optional.
  public init(
    text: String,
    detailText: DetailText,
    icon: Icon? = nil,
    customization: ((UITableViewCell, Row & RowStyle) -> Void)? = nil,
    action: ((Row) -> Void)? = nil,
    accessoryButtonAction: ((Row) -> Void)? = nil
  ) {
    self.text = text
    self.detailText = detailText
    self.icon = icon
    self.customize = customization
    self.action = action
    self.accessoryButtonAction = accessoryButtonAction
  }
    
  // MARK: - Row

  /// The text of the row.
  public let text: String

  /// The detail text of the row.
  public let detailText: DetailText?

  /// A closure that will be invoked when the row is selected.
  public let action: ((Row) -> Void)?

  /// A closure that will be invoked when the accessory button is selected.
  public let accessoryButtonAction: ((Row) -> Void)?

  // MARK: - RowStyle

  /// The type of the table view cell to display the row.
  public let cellType: SettingsTableViewCell.Type = T.self

  /// Returns the reuse identifier of the table view cell to display the row.
  public var cellReuseIdentifier: String {
    return T.reuseIdentifier + (detailText?.style.stringValue ?? "")
  }

  /// Returns the table view cell style for the specified detail text.
  public var cellStyle: UITableViewCell.CellStyle {
    return detailText?.style ?? .default
  }

  /// The icon of the row.
  public let icon: Icon?

  /// Returns the accessory type with the disclosure indicator when `action` is not nil,
  /// and with the detail button when `accessoryButtonAction` is not nil.
  public var accessoryType: UITableViewCell.AccessoryType {
      switch (action, accessoryButtonAction) {
      case (nil, nil):      return .none
      case (.some, nil):    return .disclosureIndicator
      case (nil, .some):    return .detailButton
      case (.some, .some):  return .detailDisclosureButton
      }
  }

  /// The `NavigationRow` is selectable when action is not nil.
  public var isSelectable: Bool {
    return action != nil
  }

  /// The additional customization during cell configuration.
  public let customize: ((UITableViewCell, Row & RowStyle) -> Void)?

  // MARK: Equatable

  /// Returns true iff `lhs` and `rhs` have equal titles, detail texts and icons.
  public static func == (lhs: NavigationRow, rhs: NavigationRow) -> Bool {
    return
      lhs.text == rhs.text &&
      lhs.detailText == rhs.detailText &&
      lhs.icon == rhs.icon
  }

}


internal extension UITableViewCell.CellStyle {

  var stringValue: String {
    switch self {
    case .default:    return ".default"
    case .subtitle:   return ".subtitle"
    case .value1:     return ".value1"
    case .value2:     return ".value2"
    @unknown default: return ".default"
    }
  }

}
