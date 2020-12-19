//
//  DateExtension.swift
//  CalDo
//
//  Created by Fabian Jaeger on 27.07.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import Foundation
import UIKit


extension Date {
    func dateToString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

func computeNewDate(from fromDate: Date, to toDate: Date) -> Date {
     let delta = toDate - fromDate // `Date` - `Date` = `TimeInterval`
     let today = Date()
     if delta < 0 {
         return today
     } else {
         return today + delta // `Date` + `TimeInterval` = `Date`
     }
    }
}

extension Date {
    func todoString(withTime: Bool) -> String {
        let cal = Calendar.current

        // E.g. 10:30
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        var timeString = ""
        if (withTime) {
            timeString = " " + timeFormatter.string(from: self)
        }
        
        // E.g. Dec 19 2020
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let weekdayFormatter = DateFormatter()
        // E.g. Saturday
        weekdayFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        
        let dateNoYearFormatter = DateFormatter()
        // E.g. Dec 19
        dateNoYearFormatter.setLocalizedDateFormatFromTemplate("MMM d")

        let date1 = cal.startOfDay(for: Date())
        let date2 = cal.startOfDay(for: self)

        let components2 = cal.dateComponents([.day], from: date1, to: date2)
        
        if cal.isDateInToday(self) {
            return "Today" + timeString
        }
        if cal.isDateInTomorrow(self) {
            return "Tomorrow" + timeString
        }
        if cal.isDateInYesterday(self) {
            return "Yesterday" + timeString
        }
        if components2.day! >= 2 && components2.day! < 7 {
            // return "\(dateformatter.string(from: self)) \(timeString)"
            return "\(weekdayFormatter.string(from: self))" + timeString
        }
//        if components2.day! > 7 {
//            return dateformatter2.string(from: self) + timeString
//        }
        
            
//        if (withTime) {
//            return self.DatetoString(dateFormat: "MMM d yyyy HH:mm" )
//        }
//        else {
//            return self.DatetoString(dateFormat: "MMM d yyyy" )
//        }

        if cal.dateComponents([.year], from: date1) == cal.dateComponents([.year], from: date2) {
            return "\(dateNoYearFormatter.string(from: self))" + timeString
        }
        else {
            return "\(dateFormatter.string(from: self))" + timeString
        }
    }
}


extension Date {
    func upcomingSectionTitle() -> String {
        let cal = Calendar.current
        
        let weekdayFormatter = DateFormatter()
        // E.g. Saturday
        weekdayFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        
        let dateNoYearFormatter = DateFormatter()
        // E.g. Dec 19
        dateNoYearFormatter.setLocalizedDateFormatFromTemplate("MMM d")
        
        let dateNoYearString = "  ·  " + dateNoYearFormatter.string(from: self)
        
        let date1 = cal.startOfDay(for: Date())
        let date2 = cal.startOfDay(for: self)

        let dayDifferenceComponent = cal.dateComponents([.day], from: date1, to: date2)
        
        if dayDifferenceComponent.day! < 0 {
            return "Overdue"
        }
        if cal.isDateInToday(self) {
            return "Today" + dateNoYearString
        }
        if cal.isDateInTomorrow(self) {
            return "Tomorrow" + dateNoYearString
        }
  
        if dayDifferenceComponent.day! >= 2 && dayDifferenceComponent.day! < 7 {
            return "\(weekdayFormatter.string(from: self))" + dateNoYearString
        }

        // E.g. December
        let monthCurrentYearFormatter = DateFormatter()
        monthCurrentYearFormatter.setLocalizedDateFormatFromTemplate("MMMM")
        
        // E.g. March 2022
        let monthOtherYearFormatter = DateFormatter()
        monthOtherYearFormatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        
        if cal.dateComponents([.year], from: self) == cal.dateComponents([.year], from: Date()) {
            if cal.dateComponents([.month], from: self) == cal.dateComponents([.month], from: Date()) {
                return "This Month"
            }
            return monthCurrentYearFormatter.string(from: self)
        }
        return monthOtherYearFormatter.string(from: self)
        
    }
}

extension Date {
    func todoColor(withTime: Bool) -> UIColor {
        let cal = Calendar.current
        
        let date1 = cal.startOfDay(for: Date())
        let date2 = cal.startOfDay(for: self)
        
        let dayDifference = cal.dateComponents([.day], from: date1, to: date2)
        
        if (withTime) {
            if (self < Date()) {
                return UIColor.systemRed
            }
            if cal.isDateInToday(self) {
                return UIColor.systemGreen
            }
        }
        else {
            if cal.isDateInToday(self) {
                return UIColor.systemGreen
            }
            if (self < Date()) {
                return UIColor.systemRed
            }
        }
        
        if cal.isDateInTomorrow(self) {
            return UIColor.systemOrange
        }
        if dayDifference.day! >= 2 && dayDifference.day! < 7 {
            return UIColor.systemPurple
        }
        return UIColor.systemGray
    }
}


extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "EEEE"
        return dateFormatter1.string(from: self).capitalized
    }
    func DateNumber() -> String? {
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "d"
        return dateFormatter2.string(from: self).capitalized
    }
    func month() -> String? {
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "MMMM"
        return dateFormatter3.string(from: self).capitalized
    }
}

public extension UIView {
    func round() {
        let width = bounds.width < bounds.height ? bounds.width : bounds.height
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(ovalIn: CGRect(x: bounds.midX - width / 2, y: bounds.midY - width / 2, width: width, height: width)).cgPath
        self.layer.mask = mask
    }
}



extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}



// Call like this:
//let today = Date()
//today.toString(dateFormat: "dd-MM")
