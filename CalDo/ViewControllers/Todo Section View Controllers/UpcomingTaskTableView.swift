//
//  UpcomingTaskTableView.swift
//  CalDo
//
//  Created by Nathan Baudis  on 12/17/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class UpcomingTaskTableView: TaskTableView {
    
    var hierarchicalData = [[TaskEntity]]()
    var sectionTitles = [String]()
    
    override func taskAtIndexPath(_ indexPath: IndexPath) -> TaskEntity {
        return hierarchicalData[indexPath.section][indexPath.row]
    }
    
    override init?(_ tv: UITableView, _ predicate: NSPredicate, _ sortVariable: String) {
        super.init(tv, predicate, sortVariable)
        tableView.register(UpcomingHeaderView.nib, forHeaderFooterViewReuseIdentifier: UpcomingHeaderView.identifier)
    }
    
    
    func refreshSections() {
        hierarchicalData = [[TaskEntity]]()
        
        let tasks = isFiltering ? filteredTableViewData : tableViewData

        let cal = Calendar.current
        
        let currentDate = cal.startOfDay(for: Date())
  
        // Group into dictionary by date differences
        let dayDifferenceDictionary = Dictionary(grouping: tasks, by: {(task: TaskEntity) -> Int in
            let date = task.value(forKey: "date") as! Date
            return (cal.dateComponents([.day], from: currentDate, to: date).day ?? 0)
        })
        
        // Get overdue tasks into overdue section
        var overdueTasks = [TaskEntity]()
        for key in dayDifferenceDictionary.keys {
            if key < 0 {
                overdueTasks += dayDifferenceDictionary[key]!
            }
        }
        if !overdueTasks.isEmpty {
            hierarchicalData.append(overdueTasks)
            sectionTitles.append("Overdue")
        }
        
        // Tasks further away than a week
        var monthTasks = [TaskEntity]()
        
        for key in dayDifferenceDictionary.keys.sorted() {
            // Get tasks from the next week into own sections
            if key >= 0 && key < 7 {
                hierarchicalData.append(dayDifferenceDictionary[key]!)
                // Take first task to get section title
                let sampleTask = dayDifferenceDictionary[key]![0]
                let sampleDate = sampleTask.value(forKey: "date") as! Date
                sectionTitles.append(sampleDate.upcomingSectionTitle())
            }
            if key > 7 {
                monthTasks += dayDifferenceDictionary[key]!
            }
        }
        
        // Group remaining tasks into dictionary by month differences
        let monthDifferenceDictionary = Dictionary(grouping: monthTasks, by: {(task: TaskEntity) -> Int in
            let date = task.value(forKey: "date") as! Date
            return (cal.dateComponents([.day], from: currentDate, to: date).month ?? 0)
        })
        
        // Make month sections
        for key in monthDifferenceDictionary.keys.sorted() {
            hierarchicalData.append(monthDifferenceDictionary[key]!)
            // Task first task to get section title
            let sampleTask = monthDifferenceDictionary[key]![0]
            let sampleDate = sampleTask.value(forKey: "date") as! Date
            sectionTitles.append(sampleDate.upcomingSectionTitle())
        }
    }
    
    override func completeTask(indexPath: IndexPath) {
        self.tableView.performBatchUpdates({
            super.completeTask(indexPath: indexPath)
            refreshSections()
            print(hierarchicalData.count)
        })

    }
    
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//       return sectionTitles[section]
//    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hierarchicalData[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return hierarchicalData.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
        
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: UpcomingHeaderView.identifier) as? UpcomingHeaderView {
            
            let text = sectionTitles[section]
            let attributedText = NSMutableAttributedString(string: text)
            // If title has a date (after ·), split to change font color and weight
            let subStrings = text.components(separatedBy: "·")
            
            func getRangeOfSubString(subString: String, fromString: String) -> NSRange {
                let sampleLinkRange = fromString.range(of: subString)!
                let startPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.lowerBound)
                let endPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.upperBound)
                let linkRange = NSMakeRange(startPos, endPos - startPos)
                return linkRange
            }
            
            attributedText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.label], range: getRangeOfSubString(subString: subStrings[0], fromString: text))
            if subStrings.count > 1 {
                attributedText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel], range: getRangeOfSubString(subString: "·" + subStrings[1], fromString: text))
                attributedText.addAttributes([NSAttributedString.Key.font: UIFont(name: "SFProRounded-SemiBold", size: 20)!], range: getRangeOfSubString(subString: subStrings[1], fromString: text))
            }
            
            headerView.sectionTitle.attributedText = attributedText
            
            if sectionTitles[section] == "Overdue" {
                headerView.sectionTitle.textColor = .systemRed
            }
            
            return headerView
    }
    return UIView()
    }
}

