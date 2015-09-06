//
//  QuickTableViewController.swift
//  QuickTableViewController
//
//  Created by Ben on 25/08/2015.
//  Copyright (c) 2015 bcylin.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

public class QuickTableViewController: UITableViewController {

  public var tableContents: [Section] = [] {
    didSet {
      tableView.reloadData()
    }
  }

  // MARK: - Initializer

  convenience init() {
    self.init(style: .Grouped)
  }

  // MARK: - UIViewController

  override public func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerClass(TapActionCell.self, forCellReuseIdentifier: NSStringFromClass(TapActionCell.self))
  }

  // MARK: - UITableViewDataSource

  public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return tableContents.count
  }

  public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableContents[section].rows.count
  }

  public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return tableContents[section].title
  }

  public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let row = tableContents[indexPath.section].rows[indexPath.row]
    var cell: UITableViewCell!

    if let subtitle = row.subtitle {
      cell = tableView.dequeueReusableCellWithIdentifier(".Subtitle") as? UITableViewCell
      cell = cell ?? UITableViewCell(style: .Subtitle, reuseIdentifier: ".Subtitle")
      cell.detailTextLabel?.text = subtitle

    } else if let _ = row.tapAction {
      cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TapActionCell.self)) as? UITableViewCell
      cell = cell ?? TapActionCell(style: .Default, reuseIdentifier: NSStringFromClass(TapActionCell.self))

    } else {
      cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell.self)) as? UITableViewCell
      cell = cell ?? UITableViewCell(style: .Default, reuseIdentifier: NSStringFromClass(UITableViewCell.self))
    }

    cell.accessoryType = (row.navigation == nil) ? .None : .DisclosureIndicator
    cell.textLabel?.text = row.title
    return cell
  }

  // MARK: - UITableViewDelegate

  public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let row = tableContents[indexPath.section].rows[indexPath.row]

    if let tapAction = row.tapAction {
      tapAction()
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    } else if let navigation = row.navigation {
      navigation()
    } else {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  }

}