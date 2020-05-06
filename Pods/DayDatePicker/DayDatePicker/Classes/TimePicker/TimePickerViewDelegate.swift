//
//  TimePickerViewDelegate.swift
//  DayDatePicker
//
//  Created by Hugh Bellamy on 05/02/2018.
//

import UIKit

@objc public enum TimePickerViewColumn: Int {
    case hour
    case minute
}


@objc public protocol TimePickerViewDelegate {
    @objc optional func customizeCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath, forType type: TimePickerViewColumn)
    func didSelectTime(hour: NSInteger, minute: NSInteger)
}

extension TimePickerViewDelegate {
    func customizeCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath, forType type: TimePickerViewColumn) { }
}
