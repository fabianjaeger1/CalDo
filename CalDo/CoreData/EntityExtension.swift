//
//  EntityExtension.swift
//  CalDo
//
//  Created by Nathan Baudis  on 8/15/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import Foundation
import CoreData


// MARK: -- Sorting

extension Array where Element == TaskEntity {
    mutating func sortByDate() {
        if !self.isEmpty {
            self.sort{
                let date1 = $0.value(forKey: "date") as? Date
                let date2 = $1.value(forKey: "date") as? Date
                
                switch(date1, date2) {
                case (nil, nil):
                    return ($0.value(forKey: "title") as! String) < ($1.value(forKey: "title") as! String)
                case (_, nil):
                    return true
                case (nil, _):
                    return false
                default:
                    return date1!.compare(date2!) == .orderedAscending
                }
            }
        }
    }
    
    mutating func sortByTitle() {
        if !self.isEmpty {
            self.sort{
                ($0.value(forKey: "title") as! String) < ($1.value(forKey: "title") as! String)
            }
        }
    }
    
    mutating func sortByPriority() {
        if !self.isEmpty {
            self.sort{
                ($0.value(forKey: "priority") as! Int) > ($1.value(forKey: "priority") as! Int)
            }
        }
    }
    
}

