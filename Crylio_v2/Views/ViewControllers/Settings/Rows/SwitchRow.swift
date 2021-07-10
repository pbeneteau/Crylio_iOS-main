//
//  SwitchRow.swift
//  QuickTableViewController
//
//  Created by Ben on 01/09/2015.
//  Copyright (c) 2015 bcylin.

import UIKit

/// A class that represents a row with a switch.
open class SwitchRow<T: SwitchCell>: SwitchRowCompatible, Equatable {

  // MARK: - Initializer

  /// Initializes a `SwitchRow` with a title, a switch state and an action closure.
  /// The detail text, icon and the customization closure are optional.
  public init(
    text: String,
    detailText: DetailText? = nil,
    switchValue: Bool,
    icon: Icon? = nil,
    customization: ((UITableViewCell, Row & RowStyle) -> Void)? = nil,
    action: ((Row) -> Void)?
  ) {
    self.text = text
    self.detailText = detailText
    self.switchValue = switchValue
    self.icon = icon
    self.customize = customization
    self.action = action
  }

  // MARK: - SwitchRowCompatible

  /// The state of the switch.
  public var switchValue: Bool = false {
    didSet {
      guard switchValue != oldValue else {
        return
      }
      DispatchQueue.main.async {
        self.action?(self)
      }
    }
  }

  // MARK: - Row

  /// The text of the row.
  public let text: String

  /// The detail text of the row.
  public let detailText: DetailText?

  /// A closure that will be invoked when the `switchValue` is changed.
  public let action: ((Row) -> Void)?

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

  /// The default accessory type is `.none`.
  public let accessoryType: UITableViewCell.AccessoryType = .none

  /// The `SwitchRow` should not be selectable.
  public let isSelectable: Bool = false
    
  /// The additional customization during cell configuration.
  public let customize: ((UITableViewCell, Row & RowStyle) -> Void)?

  // MARK: - Equatable

  /// Returns true iff `lhs` and `rhs` have equal titles, detail texts, switch values, and icons.
  public static func == (lhs: SwitchRow, rhs: SwitchRow) -> Bool {
    return
      lhs.text == rhs.text &&
      lhs.detailText == rhs.detailText &&
      lhs.switchValue == rhs.switchValue &&
      lhs.icon == rhs.icon
  }

}
