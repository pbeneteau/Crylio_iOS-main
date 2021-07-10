//
//  Section.swift
//  QuickTableViewController
//
//  Created by Ben on 01/09/2015.
//  Copyright (c) 2021 bcylin.

import Foundation

/// A class that represents a section in a table view.
open class Section {

  // MARK: - Initializer

  /// Initializes a section with a nullable title, containing rows and an optional footer.
  public init(title: String?, rows: [Row & RowStyle], footer: String? = nil) {
    self.title = title
    self.rows = rows
    self.footer = footer
  }

  // MARK: - Properties

  /// The text of the section title.
  public let title: String?

  /// The array of rows in the section.
  open var rows: [Row & RowStyle]

  /// The text of the section footer.
  open var footer: String?

}
