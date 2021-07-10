//
//  TapActionRow.swift
//  QuickTableViewController
//

import UIKit

/// A class that represents a row that triggers certain action when selected.
open class TapActionRow<T: TapActionCell>: TapActionRowCompatible, Equatable {

  // MARK: - Initializer

  /// Initializes a `TapActionRow` with a text, an action closure,
  /// and an optional customization closure.
  public init(
    text: String,
    customization: ((UITableViewCell, Row & RowStyle) -> Void)? = nil,
    action: ((Row) -> Void)?
  ) {
    self.text = text
    self.customize = customization
    self.action = action
  }

  // MARK: - Row

  /// The text of the row.
  public let text: String

  /// The detail text is disabled in `TapActionRow`.
  public let detailText: DetailText? = nil

  /// A closure that will be invoked when the row is selected.
  public let action: ((Row) -> Void)?

  // MARK: - RowStyle

  /// The type of the table view cell to display the row.
  public let cellType: SettingsTableViewCell.Type = T.self

  /// The reuse identifier of the table view cell to display the row. The default value is **TapActionCell**.
  public let cellReuseIdentifier: String = T.reuseIdentifier

  /// The cell style is `.default`.
  public let cellStyle: UITableViewCell.CellStyle = .default

  /// The default icon is nil.
  public let icon: Icon? = nil

  /// The default accessory type is `.none`.
  public let accessoryType: UITableViewCell.AccessoryType = .none

  /// The `TapActionRow` is selectable when action is not nil.
  public var isSelectable: Bool {
    return action != nil
  }

  /// The additional customization during cell configuration.
  public let customize: ((UITableViewCell, Row & RowStyle) -> Void)?

  // MARK: - Equatable

  /// Returns true iff `lhs` and `rhs` have equal titles and detail texts.
  public static func == (lhs: TapActionRow, rhs: TapActionRow) -> Bool {
    return
      lhs.text == rhs.text &&
      lhs.detailText == rhs.detailText
  }

}
