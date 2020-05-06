//
//  DayDatePickerViewDelegate.swift
//  DayDatePicker
//
//  Created by Hugh Bellamy on 05/02/2018.
//

import UIKit

@objc public enum DayDatePickerViewColumn: Int {
    case day
    case month
    case year
}

@objc public protocol DayDatePickerViewDelegate {
    @objc optional func customizeCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath, forType type: DayDatePickerViewColumn)
    func didSelectDate(day: NSInteger, month: NSInteger, year: NSInteger)
}

extension DayDatePickerViewDelegate {
    func customizeCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath, forType type: DayDatePickerViewColumn) { }
}
