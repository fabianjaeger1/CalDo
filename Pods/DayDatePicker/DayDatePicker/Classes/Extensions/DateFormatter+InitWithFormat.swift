//
//  DateFormatter+InitWithFormat.swift
//  DayDatePicker
//
//  Created by Hugh Bellamy on 01/02/2018.
//

import Foundation

public extension DateFormatter {
    convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
}
