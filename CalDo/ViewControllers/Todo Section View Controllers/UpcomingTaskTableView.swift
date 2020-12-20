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



class UpcomingTaskTableView: TaskTableView, UITableViewDropDelegate {
    
    var hierarchicalData = [[TaskEntity]]()
    var sectionTitles = [String]()
    
    override func taskAtIndexPath(_ indexPath: IndexPath) -> TaskEntity {
        return hierarchicalData[indexPath.section][indexPath.row]
    }
    
    override init?(_ tv: UITableView, _ predicate: NSPredicate, _ sortVariable: String) {
        super.init(tv, predicate, sortVariable)
        tableView.register(UpcomingHeaderView.nib, forHeaderFooterViewReuseIdentifier: UpcomingHeaderView.identifier)
        tableView.dropDelegate = self
    }
    
    
    func refreshSections() {
        hierarchicalData = [[TaskEntity]]()
        sectionTitles = [String]()
        
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
            if key >= 7 {
                monthTasks += dayDifferenceDictionary[key]!
            }
        }
        
        // Group remaining tasks into dictionary by month differences
        let monthDifferenceDictionary = Dictionary(grouping: monthTasks, by: {(task: TaskEntity) -> Int in
            let date = task.value(forKey: "date") as! Date
            return (cal.dateComponents([.month], from: currentDate, to: date).month!)
        })
        
        // Make month sections
        for key in monthDifferenceDictionary.keys.sorted() {
            hierarchicalData.append(monthDifferenceDictionary[key]!)
            // Take first task to get section title
            let sampleTask = monthDifferenceDictionary[key]![0]
            let sampleDate = sampleTask.value(forKey: "date") as! Date
            sectionTitles.append(sampleDate.upcomingSectionTitle())
        }
    }
    
    override func completeTask(indexPath: IndexPath) {
        let oldNumberOfSections = hierarchicalData.count
        self.tableView.performBatchUpdates({
            super.completeTask(indexPath: indexPath)
            refreshSections()
            let newNumberOfSections = hierarchicalData.count
            if oldNumberOfSections != newNumberOfSections {
                tableView.deleteSections([indexPath.section], with: .fade)
            }
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
    
    // MARK: - Search Bar
    override func filterTasksForSearchText(_ searchText: String) {
        filteredTableViewData = tableViewData.filter { (task: TaskEntity) -> Bool in
            return task.title!.lowercased().contains(searchText.lowercased())
        }
        refreshSections()
        tableView.reloadData()
    }
    
    
    // MARK: - Reordering
    
    override func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // Not necessary, but apparently there can be a bug with empty init
        let itemProvider = NSItemProvider(object: "Move" as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        dragItem.localObject = [indexPath.section, hierarchicalData[indexPath.section][indexPath.row]]
        return [dragItem]
    }

    func tableView(_ _tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else if session.items.count == 1 {
                // One item, check if the section matches
                if let sourceSection = (session.items[0].localObject as? [Any])?[0] as? Int, let destinationSection = destinationIndexPath?.section {
                    if sourceSection == destinationSection {
                        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
                    }
                }
            }
            return UITableViewDropProposal(operation: .cancel)
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        // Needed for drop delegate, but not called when dragging & dropping in table
        print("perform Drop")
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == destinationIndexPath.section {
            let mover = hierarchicalData[sourceIndexPath.section].remove(at: sourceIndexPath.row)
            hierarchicalData[destinationIndexPath.section].insert(mover, at: destinationIndexPath.row)
            // self.saveOrder()
        }

    }

}



