//
//  DateExtension.swift
//  CalDo
//
//  Created by Fabian Jaeger on 27.07.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import Foundation
import UIKit


extension Date
{
    func DatetoString(dateFormat format: String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

extension Date {
    func todoString(withTime: Bool) -> String {
        let cal = Calendar.current

        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        
        var timeString = ""
        if (withTime) {
            timeString = timeformatter.string(from: self)
        }
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEEE"
        
        let dateformatter2 = DateFormatter()
        if (withTime) {
            dateformatter2.dateFormat = "d MMM HH:mm"
        }
        else {
            dateformatter2.dateFormat = "d MMM"
        }

        let date1 = cal.startOfDay(for: Date())
        let date2 = cal.startOfDay(for: self)

        let components2 = cal.dateComponents([.day], from: date1, to: date2)
        
        // TODO: leave out space if there is no time
        if Calendar.current.isDateInToday(self) {
            return "Today " + timeString
        }
        if Calendar.current.isDateInTomorrow(self) {
            return "Tomorrow " + timeString
        }
        if Calendar.current.isDateInYesterday(self) {
            return "Yesterday " + timeString
        }
        if components2.day! > 2 && components2.day! < 7 {
            return "\(dateformatter.string(from: self)) \(timeString)"
        }
        if components2.day! > 7 {
            return dateformatter2.string(from: self)
        }
        
//        if (withTime) {
//            return self.DatetoString(dateFormat: "MMM d yyyy HH:mm" )
//        }
//        else {
//            return self.DatetoString(dateFormat: "MMM d yyyy" )
//        }
        // TODO: check if the year is the same, if yes, leave out the year?
        return self.DatetoString(dateFormat: "MMM d yyyy ") + timeString
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

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
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
