//
//  DetailText.swift
//  QuickTableViewController
//
//  Created by bcylin on 31/12/2018.
//  Copyright © 2021 bcylin.


import UIKit

/// An enum that represents a detail text with `UITableViewCell.CellStyle`.
public enum DetailText: Equatable {

  /// Does not show a detail text in `UITableViewCell.CellStyle.default`.
  case none
  /// Shows the detail text in `UITableViewCell.CellStyle.subtitle`.
  case subtitle(String)
  /// Shows the detail text in `UITableViewCell.CellStyle.value1`.
  case value1(String)
  /// Shows the detail text in `UITableViewCell.CellStyle.value2`.
  case value2(String)

  /// Returns the corresponding table view cell style.
  public var style: UITableViewCell.CellStyle {
    switch self {
    case .none:     return .default
    case .subtitle: return .subtitle
    case .value1:   return .value1
    case .value2:   return .value2
    }
  }

  /// Returns the associated text of the case.
  public var text: String? {
    switch self {
    case .none:
      return nil
    case let .subtitle(text), let .value1(text), let .value2(text):
      return text
    }
  }

}
